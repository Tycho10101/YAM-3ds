font = {}

local json = require "json"

function font.init()
    font.definitions, _ = love.filesystem.read("assets/font.json")
	font.definitions = json.decode(font.definitions)
end

return font