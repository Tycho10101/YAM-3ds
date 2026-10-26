-- Setup nest if not on 3ds
local osName = love.system.getOS()
if osName ~= "Horizon" and osName ~= "Cafe" then
	require("nest").init({console = "3ds", scale = 1})
end

json = require "json"

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
		screen_data, _ = love.filesystem.read("gui/" .. screen_name .. ".json")
		screen_data = json.decode(screen_data)
		collectgarbage("collect")
		for screen, value in pairs(screen_data) do
			print(screen, value)
			for	index, widget in ipairs(value) do
				if widget.type == "image" then
					widget.image = love.graphics.newImage("textures/" .. widget.src)
				else
					error("Unknown widget type: " .. widget.type)
				end
			end
		end
	end
end

function render_ui(screen)
	for	index, widget in ipairs(screen_data[screen]) do
		if widget.type == "image" then
			love.graphics.draw(widget.image, 0, 0)
		else
			error("No renderer for widget type: " .. widget.type)
		end
	end
end


function render_top(screen)
	render_ui(screen)
end

function render_bottom(screen)

end

function love.draw(screen)
    local width, height = love.graphics.getDimensions(screen)
	
    if screen == "bottom" or screen == "gamepad" then
		render_bottom('bottom')
	else
		render_top('top')
	end

	love.graphics.print(screen, 0, 0)
end

function love.gamepadpressed(joystick, button)
	love.event.quit()
end