utils = {}

utils.touch = {x = 0, y = 0}

function utils.get_screen_size(screen)
	return (screen == "bottom") and 320 or 400, 240
end

function utils.check_point_collide(px, py, bx, by, bw, bh)
    return px >= bx and px <= bx + bw and
           py >= by and py <= by + bh
end

function utils.get_touch_position()
    if nest_args and love.mouse then
        local tw, th = utils.get_screen_size("top")
        local bw, bh = utils.get_screen_size("bottom")
        local mx, my = love.mouse.getPosition()
        
        utils.touch.x = (mx / nest_args.scale) - (tw - bw) / 2
        utils.touch.y = (my / nest_args.scale) - th
    else
        local touch = love.touch.getTouches()[1]
        if touch then
            utils.touch.x, utils.touch.y = love.touch.getPosition(touch)
        end
    end
    return utils.touch.x, utils.touch.y
end

return utils