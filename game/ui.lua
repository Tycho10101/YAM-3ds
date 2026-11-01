ui = {}

local json = require "json"
local utilities = require "utils"

function ui.load_screen(screen_name)
	local screen_data, _ = love.filesystem.read("gui/" .. screen_name .. ".json")
	local screen_data = json.decode(screen_data)

    local screen_code = require("gui/" .. screen_name)

	for screen, value in pairs(screen_data) do
		for	_, container in ipairs(value) do
			container.h = 0

			for	index, widget in ipairs(container.elements) do

				if widget.type == "image" then
					widget.image = love.graphics.newImage("textures/" .. widget.src .. ".png")
					widget.w, widget.h = widget.image:getDimensions()
				elseif widget.type == "button" then
					widget.w, widget.h = 200, 20
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

    screen_data = screen_code.init(screen_data)
	return screen_data
end

function ui.render_ui(screen, screen_data, textures)
	local screen_width, screen_height = utils.get_screen_size(screen)
    local px, py = utils.get_touch_position()

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
			elseif widget.type == "button" then
                local collide = utils.check_point_collide(px, py, x, y, widget.w, widget.h)
                if collide then
                    love.graphics.draw(textures["buttons/button_highlighted"], x, y)
                else
				    love.graphics.draw(textures["buttons/button"], x, y)
                end
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

function ui.draw_background(screen)
	local screen_width, screen_height = utils.get_screen_size(screen)
	
	for x = 0, screen_width - 16, 16 do
		for y = 0, 240 - 16, 16 do
			love.graphics.draw(textures["background"], x, y)
		end
	end
end

return ui