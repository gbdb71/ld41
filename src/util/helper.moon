Helper = {}

Helper.directionToVector = (str) ->
    switch (string.lower(str))
        when "up"
            return 0, -1
        when "right"
            return 1, 0
        when "down"
            return 0, 1
        when "left"
            return -1, 0

    return 0, 0

Helper.vectorToDirection = (x, y) ->
    if (x == 0)
        if (y < 0)
            return "up"
        elseif (y > 0)
            return "down"
    elseif (y == 0)
        if (x < 0)
            return "left"
        elseif (x > 0)
            return "right"

    return ""

return Helper
