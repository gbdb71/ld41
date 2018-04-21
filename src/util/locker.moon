export class Locker
    new: =>
        @isLocked = false
        @values = {}
        @_toAdd = {}
        @_toRemove = {}

    keep: =>
        for i, v in ipairs @_toAdd
            Lume.push(@values, v)
        Lume.clear(@_toAdd)

        for i, v in ipairs @_toRemove
            Lume.remove(@values, v)
        Lume.clear(@_toRemove)

    lock: =>
        @isLocked = true

    unlock: =>
        @isLocked = false

    add: (value) =>
        if (@isLocked)
            Lume.push(@_toAdd, value)
            return

        Lume.push(@values, value)

    remove: (value) =>
        if (@isLocked)
            if (@contains(value))
                Lume.push(@_toRemove, value)
                return true

            return false

        Lume.remove(@values, value)

    clear: =>
        if (@isLocked)
            Lume.push(_toRemove, unpack(@_toAdd))
            Lume.push(_toRemove, unpack(@values))
            return

        Lume.clear(@values)

    contains: (value) =>
        for i, v in ipairs @values
            if (value == v)
                return true

        for i, v in ipairs @_toAdd
            if (value == v)
                return true
