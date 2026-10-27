-- Setup nest if not on 3ds
local osName = love.system.getOS()
if osName ~= "Horizon" and osName ~= "Cafe" then
	require("nest").init({console = "3ds", scale = 1})
end

json = require "json"
ui = require "ui"

function love.load()
	if love._console == "3DS" then
    	love.graphics.set3D(false)
	else
		function love.update(dt) end
		function love.draw(screen)
			love.graphics.print("This game doesn't support the Switch or Wii U, please use 3DS, or PC.\nPress any button to close.", 0, 0)
		end
		function love.gamepadpressed(joystick, button)
			love.event.quit()
		end
		return
	end
	
	-- shared ui texture setup
	textures = {"background", "buttons/button", "buttons/button_disabled", "buttons/button_highlighted"}
	for	index, texture in ipairs(textures) do
		textures[texture] = love.graphics.newImage("textures/ui/" .. texture .. ".png")
	end

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
		screen_data = load_screen(screen_name)
		collectgarbage("collect")
	end
end

function get_screen_size(screen)
	return (screen == "bottom") and 320 or 400
end

function load_screen(screen_name)
	screen_data, _ = love.filesystem.read("gui/" .. screen_name .. ".json")
	screen_data = json.decode(screen_data)

	for screen, value in pairs(screen_data) do
		for	_, container in ipairs(value) do
			container.h = 0

			for	index, widget in ipairs(container.elements) do

				if widget.type == "image" then
					widget.image = love.graphics.newImage("textures/" .. widget.src .. ".png")
					widget.w, widget.h = widget.image:getDimensions()
				else
					error("Unknown widget type: " .. widget.type)
				end

				container.h = container.h + widget.h
				if index > 1 then
					container.h = container.h + container.padding
				end
			end

			container.top = (240 - container.h) / 2
		end
	end
	return screen_data
end

function render_ui(screen)
	local screen_width = get_screen_size(screen)

	for	_, container in ipairs(screen_data[screen]) do
		local y_offset = 0

		for	index, widget in ipairs(container.elements) do
			local x, y = 0, 0
			if container.alignment == "center" then
				x, y = (screen_width - widget.w) / 2, container.top + y_offset
			else
				error("No renderer for alignment: " .. container.alignment)
			end

			if widget.type == "image" then
				love.graphics.draw(widget.image, x, y)
			else
				error("No renderer for widget: " .. widget.type)
			end

			y_offset = y_offset + widget.h
			if index ~= #container.elements then
				y_offset = y_offset + container.padding
			end
		end
	end
end

function draw_background(screen)
	local screen_width = get_screen_size(screen)
	
	for x = 0, screen_width - 16, 16 do
		for y = 0, 240 - 16, 16 do
			love.graphics.draw(textures["background"], x, y)
		end
	end
end

function render_top(screen)
	draw_background(screen)
end

function render_bottom(screen)
	if mode == "ui" then
		draw_background(screen)
	end
end

function love.draw(screen)
    local width, height = love.graphics.getDimensions(screen)
	
    if screen == "bottom" then
		render_bottom('bottom')
	else
		render_top('top')
	end

	render_ui(screen)

	-- Debug options
	--love.graphics.print(screen, 0, 0) -- Print screen name
end

function love.gamepadpressed(joystick, button)
	love.event.quit()
end