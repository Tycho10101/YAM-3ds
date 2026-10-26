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
	
	mode = "ui"
	screen = ""
end

function love.update(dt)

end

function render_top()

end

function render_bottom()

end

function love.draw(screen)
    local width, height = love.graphics.getDimensions(screen)
	
    if screen == "bottom" or screen == "gamepad" then
		render_bottom()
	else
		render_top()
	end

	love.graphics.print(screen, 0, 0)
end

function love.gamepadpressed(joystick, button)
	love.event.quit()
end