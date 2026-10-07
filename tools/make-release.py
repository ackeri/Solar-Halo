"""Builds the mod portal zip from a git ref, and refuses to if the zip would
contain anything executable (the portal rejects those).

    python tools/make-release.py [git ref, default HEAD] [output folder, default .]

The zip is named and versioned from the info.json at that ref, and unpacks to
a folder of the same name, like the portal expects. Files marked export-ignore
in .gitattributes (tools, docs, the README, helper scripts) are left out; this
script then checks what is left, so a script added to the repo later can't end
up in an upload by accident.
"""
import io
import json
import os
import subprocess
import sys
import zipfile

REF = sys.argv[1] if len(sys.argv) > 1 else "HEAD"
OUT = sys.argv[2] if len(sys.argv) > 2 else "."

# extensions that are programs or scripts the portal will not accept
EXECUTABLE_EXTENSIONS = {
    ".py", ".pyc", ".pyw", ".exe", ".dll", ".bat", ".cmd", ".sh", ".ps1", ".vbs", ".js",
    ".jar", ".msi", ".com", ".scr", ".so", ".dylib", ".app", ".bin", ".lnk", ".pl", ".rb", ".php",
}
# file starts that mean a program regardless of the name
EXECUTABLE_MAGIC = {b"MZ": "Windows executable", b"\x7fELF": "Linux executable", b"#!": "script with a shebang"}


def git(*args):
    return subprocess.run(["git", *args], check=True, capture_output=True).stdout


info = json.loads(git("show", f"{REF}:info.json"))
folder = f"{info['name']}_{info['version']}"
archive = git("archive", "--format=zip", f"--prefix={folder}/", REF)

problems = []
with zipfile.ZipFile(io.BytesIO(archive)) as z:
    for entry in z.infolist():
        if entry.is_dir():
            continue
        name = entry.filename
        if os.path.splitext(name)[1].lower() in EXECUTABLE_EXTENSIONS:
            problems.append(f"{name}: executable file type")
        if (entry.external_attr >> 16) & 0o111:
            problems.append(f"{name}: has the executable permission bit")
        head = z.read(name)[:4]
        for magic, what in EXECUTABLE_MAGIC.items():
            if head.startswith(magic):
                problems.append(f"{name}: {what}")

if problems:
    print("Not writing the zip, it would contain executable files:")
    for problem in sorted(set(problems)):
        print("  " + problem)
    print("Add them to .gitattributes as export-ignore, or remove them.")
    sys.exit(1)

os.makedirs(OUT, exist_ok=True)
target = os.path.join(OUT, folder + ".zip")
with open(target, "wb") as f:
    f.write(archive)
print(f"wrote {target} ({len(archive) // 1024} KB, {info['name']} {info['version']}, factorio {info['factorio_version']}) from {REF}")
