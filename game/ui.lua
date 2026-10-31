ui = {}

function ui.get_screen_size(screen)
	return (screen == "bottom") and 320 or 400, 240
end

function ui.load_screen(screen_name)
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

function ui.render_ui(screen, screen_data)
	local screen_width, screen_height = ui.get_screen_size(screen)

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

function ui.draw_background(screen)
	local screen_width, screen_height = ui.get_screen_size(screen)
	
	for x = 0, screen_width - 16, 16 do
		for y = 0, 240 - 16, 16 do
			love.graphics.draw(textures["background"], x, y)
		end
	end
end

return ui