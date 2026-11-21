font = {}

local json = require "json"
local utils = require "utils"

local function _get_letter_width(image_data, quad)
    local qx, qy, qw, qh = quad:getViewport()
    local minx = qw
    local maxx = -1

    for y = 0, qh - 1 do
        for x = 0, qw - 1 do
            local _, _, _, a = image_data:getPixel(qx + x, qy + y)
            if a > 0 then
                if x < minx then minx = x end
                if x > maxx then maxx = x end
            end
        end
    end

    if maxx < minx then
        return 3
    end

    local trimmedWidth = (maxx - minx) + 1
    return trimmedWidth
end


function font.init(texture_location, definition_location)
    local texture_location = texture_location or "assets/ui/font.png"
    local definition_location = definition_location or "assets/ui/font.json"

    font._definitions, _ = love.filesystem.read(definition_location)
	font._definitions = json.decode(font._definitions)

    font._raw_tex = love.image.newImageData(texture_location)
    font._full_tex = love.graphics.newImage(font._raw_tex)
    font._quads = {}

    local w, h = font._full_tex:getDimensions()

    for y = 0, h - 8, 8 do
        for x = 0, w - 8, 8 do
            local char = love.graphics.newQuad(x, y, 8, 8, w, h)
            table.insert(font._quads, char)
        end
    end

    font._characters = {}
    for char, index in pairs(font._definitions) do
        font._characters[char] = {quad = font._quads[index], width = _get_letter_width(font._raw_tex, font._quads[index])}
    end
end

function font.create(text)
    local w, h = font._calculate_width(text)
    local canvas = love.graphics.newCanvas(w + 1, h + 1)

    canvas:renderTo(love.graphics.clear, 0, 0, 0, 0)
    canvas:setFilter("nearest", "nearest")

    love.graphics.setColor(0, 0, 0, 0.5)
    canvas:renderTo(font._raw_print, text, 1, 1)
    love.graphics.setColor(1, 1, 1, 1)
    canvas:renderTo(font._raw_print, text, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)

    return canvas
end

function font.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    x = x or 0
    y = y or 0
    r = r or 0
    sx = sx or 1
    sy = sy or sx
    ox = ox or 0
    oy = oy or 0
    kx = kx or 0
    ky = ky or 0

    love.graphics.draw(font.create(text), x, y, r, sx, sy, ox, oy, kx, ky)
end

function font._raw_print(text, x, y)
    local chars = utils.get_keys(font._definitions)
    local ox = x
    local oy = y

    for i = 1, #text do
        local char = text:sub(i, i)
        if char == "\n" then
            oy = oy + 10
            ox = x
        else
            if not utils.contains(chars, char) then
                char = "_fb"
            end
            love.graphics.draw(font._full_tex, font._characters[char].quad, ox, oy)
            ox = ox + (font._characters[char].width + 1)
        end
    end
end

function font._calculate_width(text)
    local chars = utils.get_keys(font._definitions)
    local w = 0
    local h = 8
    local lw = 0

    for i = 1, #text do
        local char = text:sub(i, i)
        if char == "\n" then
            h = h + 10
            lw = 0
        else
            if not utils.contains(chars, char) then
                char = "_fb"
            end
            lw = lw + (font._characters[char].width + 1)
        end

        if lw > w then
            w = lw
        end
    end
    return w - 1, h
end

return font