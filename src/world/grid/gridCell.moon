export class GridCell
    new: =>
        @walkable = true
        @thing = nil

    hasPlayer: =>
        return not (not @walkable or @thing == nil or @thing.__class.__name != "Player")

    hasEnemy: (specificEnemy) =>
        if (specificEnemy != nil)
            return not (not @walkable or @thing == nil or @thing.__class.__name != specificEnemy)


        if (not (not @walkable or @thing == nil or @thing.__class.__parent.__name != "Enemy"))
            return true, @thing.__class.__name

        return false, nil
