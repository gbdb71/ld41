export class GridCell
    new: =>
        @walkable = true
        @thing = nil
        @pickup = nil

    isEmpty: =>
        return (@walkable and @thing == nil)

    hasPlayer: =>
        return (not @isEmpty! and @thing != nil and @thing.__class.__name == "Player")

    hasEnemy: (specificEnemy) =>
        if (specificEnemy != nil)
            return (not @isEmpty! and @thing != nil and @thing.__class.__name == specificEnemy)


        if (not @isEmpty! and @thing != nil and @thing.__class.__parent.__name == "Enemy")
            return true, @thing.__class.__name

        return false, nil

    hasPickup: =>
        if (not @walkable or @pickup == nil)
            return false

        return true
