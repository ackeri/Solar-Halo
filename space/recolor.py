#!/usr/bin/env python3
"""
recolor.py – Color look-up table recoloring tool.

For every pixel in a 24-bit PNG:
  • If the pixel is "bright orange"  → keep it as-is.
  • Otherwise                         → darken it to 10 % of its original brightness.

"Bright orange" is defined in HSV space:
  Hue        :  15° – 40°   (covers the orange band, excluding red and yellow)
  Saturation :  ≥ 0.55      (vivid, not pastel or grey)
  Value      :  ≥ 0.55      (bright, not dark)

Adjust the constants below if your definition of "bright orange" differs.

Usage:
    python recolor.py <input.png> <output.png>
"""

import sys
import struct
import zlib
import io

# ---------------------------------------------------------------------------
# Orange detection thresholds (HSV, all in [0, 1] except hue in degrees)
# ---------------------------------------------------------------------------
HUE_MIN   = 15.0   # degrees
HUE_MAX   = 40.0   # degrees
SAT_MIN   = 0.55
VAL_MIN   = 0.95

# Darkening factor for non-orange pixels
DARKEN_FACTOR = 0.20   # 10 % brightness


# ---------------------------------------------------------------------------
# Minimal pure-stdlib PNG reader / writer
# (Uses only `struct`, `zlib`, and `io` — no Pillow / NumPy required.)
# ---------------------------------------------------------------------------

def _read_chunks(data: bytes):
    """Yield (chunk_type, chunk_data) from raw PNG bytes."""
    assert data[:8] == b'\x89PNG\r\n\x1a\n', "Not a valid PNG file."
    pos = 8
    while pos < len(data):
        length = struct.unpack('>I', data[pos:pos+4])[0]
        ctype  = data[pos+4:pos+8]
        cdata  = data[pos+8:pos+8+length]
        # crc  = data[pos+8+length:pos+12+length]  # verified implicitly
        pos   += 12 + length
        yield ctype, cdata


def _read_png(path: str):
    """
    Read a 24-bit (RGB, no alpha) PNG.
    Returns (width, height, pixels) where pixels is a flat bytearray of
    R,G,B triplets in row-major order.
    """
    with open(path, 'rb') as f:
        raw = f.read()

    ihdr = None
    idat_parts = []
    for ctype, cdata in _read_chunks(raw):
        if ctype == b'IHDR':
            ihdr = cdata
        elif ctype == b'IDAT':
            idat_parts.append(cdata)
        elif ctype == b'IEND':
            break

    assert ihdr is not None, "Missing IHDR chunk."
    width, height   = struct.unpack('>II', ihdr[0:8])
    bit_depth       = ihdr[8]
    color_type      = ihdr[9]
    compression     = ihdr[10]
    filter_method   = ihdr[11]
    interlace       = ihdr[12]

    assert bit_depth   == 8,  f"Unsupported bit depth {bit_depth}; expected 8."
    assert color_type  == 2,  f"Unsupported color type {color_type}; expected 2 (RGB)."
    assert compression == 0,  "Unsupported compression method."
    assert filter_method == 0,"Unsupported filter method."
    assert interlace   == 0,  "Interlaced PNGs are not supported."

    raw_idat = zlib.decompress(b''.join(idat_parts))

    # Un-filter each scanline
    stride  = width * 3          # bytes per row (RGB)
    pixels  = bytearray(width * height * 3)
    prev    = bytearray(stride)  # previous reconstructed row (zeros for row 0)

    for y in range(height):
        row_start = y * (stride + 1)          # +1 for the filter byte
        ftype     = raw_idat[row_start]
        row       = bytearray(raw_idat[row_start+1 : row_start+1+stride])

        if ftype == 0:   # None
            recon = row
        elif ftype == 1: # Sub
            recon = bytearray(stride)
            for i in range(stride):
                a = recon[i-3] if i >= 3 else 0
                recon[i] = (row[i] + a) & 0xFF
        elif ftype == 2: # Up
            recon = bytearray((row[i] + prev[i]) & 0xFF for i in range(stride))
        elif ftype == 3: # Average
            recon = bytearray(stride)
            for i in range(stride):
                a = recon[i-3] if i >= 3 else 0
                b = prev[i]
                recon[i] = (row[i] + (a + b) // 2) & 0xFF
        elif ftype == 4: # Paeth
            recon = bytearray(stride)
            for i in range(stride):
                a = recon[i-3] if i >= 3 else 0
                b = prev[i]
                c = prev[i-3] if i >= 3 else 0
                pa, pb, pc = abs(b-c), abs(a-c), abs(a+b-2*c)
                pr = a if pa <= pb and pa <= pc else (b if pb <= pc else c)
                recon[i] = (row[i] + pr) & 0xFF
        else:
            raise ValueError(f"Unknown PNG filter type {ftype} at row {y}.")

        pixels[y*stride : (y+1)*stride] = recon
        prev = recon

    return width, height, pixels


def _write_png(path: str, width: int, height: int, pixels: bytearray):
    """Write a 24-bit RGB PNG from a flat bytearray of R,G,B triplets."""
    stride = width * 3

    # Apply Sub filter (type 1) to every row — good compression, simple
    filtered = bytearray()
    for y in range(height):
        row = pixels[y*stride : (y+1)*stride]
        filtered.append(1)  # filter type: Sub
        for i in range(stride):
            a = row[i-3] if i >= 3 else 0
            filtered.append((row[i] - a) & 0xFF)

    compressed = zlib.compress(bytes(filtered), level=9)

    def make_chunk(ctype: bytes, data: bytes) -> bytes:
        crc = zlib.crc32(ctype + data) & 0xFFFFFFFF
        return struct.pack('>I', len(data)) + ctype + data + struct.pack('>I', crc)

    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    out = (
        b'\x89PNG\r\n\x1a\n'
        + make_chunk(b'IHDR', ihdr_data)
        + make_chunk(b'IDAT', compressed)
        + make_chunk(b'IEND', b'')
    )
    with open(path, 'wb') as f:
        f.write(out)


# ---------------------------------------------------------------------------
# Color helpers
# ---------------------------------------------------------------------------

def _rgb_to_hsv(r: int, g: int, b: int):
    """Convert 8-bit RGB → (hue_degrees, saturation, value) all in [0,1] / [0°,360°)."""
    rf, gf, bf = r / 255.0, g / 255.0, b / 255.0
    cmax = max(rf, gf, bf)
    cmin = min(rf, gf, bf)
    delta = cmax - cmin

    # Value
    v = cmax

    # Saturation
    s = 0.0 if cmax == 0.0 else delta / cmax

    # Hue
    if delta == 0.0:
        h = 0.0
    elif cmax == rf:
        h = 60.0 * (((gf - bf) / delta) % 6)
    elif cmax == gf:
        h = 60.0 * (((bf - rf) / delta) + 2)
    else:
        h = 60.0 * (((rf - gf) / delta) + 4)

    return h, s, v

# ---------------------------------------------------------------------------
# Main processing
# ---------------------------------------------------------------------------

def recolor(input_path: str, output_path: str):
    print(f"Reading  : {input_path}")
    width, height, pixels = _read_png(input_path)
    print(f"Image    : {width} × {height} px  ({width*height:,} pixels total)")

    orange_count = 0
    darkened_count = 0

    out_pixels = bytearray(len(pixels))
    stride = width * 3

    for y in range(height):
        for x in range(width):
            idx = y * stride + x * 3
            r, g, b = pixels[idx], pixels[idx+1], pixels[idx+2]
            h, s, v = _rgb_to_hsv(r, g, b)

            if v < .75:
                out_pixels[idx]   = round(r*(v+.25)*(v+.25)*(v+.25)*(v+.25))
                out_pixels[idx+1] = round(g*(v+.25)*(v+.25)*(v+.25)*(v+.25))
                out_pixels[idx+2] = round(b*(v+.25)*(v+.25)*(v+.25)*(v+.25))
            else:
                out_pixels[idx]   = round(r)
                out_pixels[idx+1] = round(g)
                out_pixels[idx+2] = round(b)

    total = width * height
    print(f"Bright orange pixels kept   : {orange_count:,}  ({100*orange_count/total:.2f} %)")
    print(f"Darkened to 10 % brightness : {darkened_count:,}  ({100*darkened_count/total:.2f} %)")

    print(f"Writing  : {output_path}")
    _write_png(output_path, width, height, out_pixels)
    print("Done.")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(__doc__)
        print(f"Usage: python {sys.argv[0]} <input.png> <output.png>")
        sys.exit(1)

    recolor(sys.argv[1], sys.argv[2])
