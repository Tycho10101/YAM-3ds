-- Setup nest if not on 3ds
local osName = love.system.getOS()
if osName ~= "Horizon" and osName ~= "Cafe" then
	nest_args = {console = "3ds", scale = 2}
	require("nest").init(nest_args)
end

local version = os.getenv("LOVER_PKG_VERSION")

local ui = require "ui"
font = require "font"

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	if love._console == "3DS" then
    	love.graphics.set3D(false)
	else
		function love.update(dt) end
		function love.draw(screen)
			love.graphics.print("This game doesn't support the Switch or Wii U. Please use 3DS or PC.\nPress any button to close.", 0, 0)
		end
		function love.gamepadpressed(joystick, button)
			love.event.quit()
		end
		return
	end
	
	-- shared ui texture setup
	textures = {"background", "buttons/button", "buttons/button_disabled", "buttons/button_highlighted"}
	for	index, texture in ipairs(textures) do
		textures[texture] = love.graphics.newImage("assets/ui/" .. texture .. ".png")
	end

	-- initialize font
	font.init()

	-- ui setup
	mode = "ui"
	screen_name = "title"
	screen_old = ""
	screen_data = nil
end

function love.update(dt)
	-- load new screen on change
	if screen_old ~= screen_name then
		screen_old = screen_name
		screen_data = nil
		collectgarbage("collect")
		screen_data = ui.load_screen(screen_name)
		collectgarbage("collect")
	end
end

test = 0.2
test2 = true

function render_top(screen)
	ui.draw_background(screen)
end

function render_bottom(screen)
	if mode == "ui" then
		ui.draw_background(screen)
	end
end

function love.draw(screen)
    if screen == "bottom" then
		render_bottom('bottom')
	else
		render_top('top')
	end

	ui.render_ui(screen, screen_data, textures)

	-- Debug options
	--love.graphics.print(screen, 0, 0) -- Print screen name
end

function love.gamepadpressed(joystick, button)
	love.event.quit()
end