local util = {}

util.factutil = require("util")

util.pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures
util.pipe_frozen  = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen
util.pipecoverspictures = function()
	return {
		north = {
			layers = {
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		east = {
			layers = {
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		south = {
			layers = {
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
		west = {
			layers = {
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
				},
				{
					filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
					priority = "extra-high",
					width = 128,
					height = 128,
					scale = 0.5,
					draw_as_shadow = true,
				},
			},
		},
	}
end

util.hit_effects  = require("__base__/prototypes/entity/hit-effects")

util.sounds       = require("__base__/prototypes/entity/sounds")

util.getLocalName = function(proto)
	if proto.localised_name then
		return proto.localised_name
	end
	return {"item-name." .. proto.name}
end

function make_4way_animation_from_spritesheet(animation)
  local function make_animation_layer(idx, anim)
    local frame_count = anim.frame_count or 1
    local start_frame = frame_count * idx
    local x = 0
    local y = 0
    if anim.line_length then
      y = anim.height * math.floor(start_frame / (anim.line_length or 1))
      if anim.line_length > frame_count then
        error("single line must not contain animations for multiple directions when line_lenght is specified: " .. anim.filename)
      end
    else
      x = idx * anim.width
    end
    return
    {
      filename = anim.filename,
      priority = anim.priority or "high",
      flags = anim.flags,
      x = x,
      y = y,
      width = anim.width,
      height = anim.height,
      frame_count = anim.frame_count,
      line_length = anim.line_length,
      repeat_count = anim.repeat_count,
      shift = anim.shift,
      draw_as_shadow = anim.draw_as_shadow,
      draw_as_glow = anim.draw_as_glow,
      draw_as_light = anim.draw_as_light,
      apply_runtime_tint = anim.apply_runtime_tint,
      tint_as_overlay = anim.tint_as_overlay or false,
      animation_speed = anim.animation_speed,
      scale = anim.scale or 1,
      tint = anim.tint,
      blend_mode = anim.blend_mode,
      load_in_minimal_mode = anim.load_in_minimal_mode,
      premul_alpha = anim.premul_alpha,
      generate_sdf = anim.generate_sdf
    }
  end

  local function make_animation(idx)
    if animation.layers then
      local tab = { layers = {} }
      for k,v in ipairs(animation.layers) do
        table.insert(tab.layers, make_animation_layer(idx, v))
      end
      return tab
    else
      return make_animation_layer(idx, animation)
    end
  end

  return
  {
    north = make_animation(0),
    east = make_animation(1),
    south = make_animation(2),
    west = make_animation(3)
  }
end

util.pipe_covers = make_4way_animation_from_spritesheet({
	filename = "__base__/graphics/entity/heat-exchanger/heatex-endings.png",
	width = 64,
	height = 64,
	direction_count = 4,
	scale = 0.5
})
util.heat_pipe_covers = make_4way_animation_from_spritesheet(
	apply_heat_pipe_glow{
	filename = "__base__/graphics/entity/heat-exchanger/heatex-endings-heated.png",
	width = 64,
	height = 64,
	direction_count = 4,
	scale = 0.5
})
util.heat_picture = {
	north = apply_heat_pipe_glow {
		filename = "__base__/graphics/entity/heat-exchanger/heatex-N-heated.png",
		priority = "extra-high",
		width = 44,
		height = 96,
		shift = util.factutil.by_pixel(-0.5, 8.5),
		scale = 0.5
	},
	east = apply_heat_pipe_glow {
		filename = "__base__/graphics/entity/heat-exchanger/heatex-E-heated.png",
		priority = "extra-high",
		width = 80,
		height = 80,
		shift = util.factutil.by_pixel(-21, -13),
		scale = 0.5
	},
	south = apply_heat_pipe_glow {
		filename = "__base__/graphics/entity/heat-exchanger/heatex-S-heated.png",
		priority = "extra-high",
		width = 28,
		height = 40,
		shift = util.factutil.by_pixel(-1, -30),
		scale = 0.5
	},
	west = apply_heat_pipe_glow {
		filename = "__base__/graphics/entity/heat-exchanger/heatex-W-heated.png",
		priority = "extra-high",
		width = 64,
		height = 76,
		shift = util.factutil.by_pixel(23, -13),
		scale = 0.5
	}
}

return util
