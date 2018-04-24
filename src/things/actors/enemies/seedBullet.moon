export class SeedBullet extends Enemy
    new: =>
        super(9999)
        @canTakeDamage = false

        with @graphic = ImageSet("#{Settings.folders.graphics}/bulletseed.png", 8, 5)
            .origin.x = 4
            .origin.y = 3
            .frameDuration = .130
            \play!

        @attackRange = {}

        with @movement = @addComponent(Movement(500, 500, 800, 800))
            .callbacks.onEndMove = ->
                print "end move"
                @finishTurn!

        -- attack
        @damage = 1
        @attacked = nil
        @attackDirection = x: 0, y: 0

        -- attack tween
        @attackTween = nil
        @playingAttackTween = false
        @attackMoveDistance = 14


    sceneAdded: (scene) =>
        super(scene)
        Lume.push(@attackRange, { @attackDirection.x, @attackDirection.y })
        if (@attackDirection.x > 0)
            @turnTo("right")
        elseif (@attackDirection.x < 0)
            @turnTo("left")
        elseif (@attackDirection.y > 0)
            @turnTo("down")
            @graphic.orientation = math.rad(90)
        elseif (@attackDirection.y < 0)
            @turnTo("up")
            @graphic.orientation = math.rad(-90)

    update: (dt) =>
        super(dt)
        if (@playingAttackTween)
            if (@attackTween\update(dt))
                @playingAttackTween = false

                if (@attacked != nil)
                    switch (@attacked.__class.__name)
                        when "Player"
                            @attacked\takeDamage(@damage)
                        when "SeedBullet"
                            @attacked\die!

                @die!
                @finishTurn!

    -- health
    onDeath: =>
        super!
        @removeSelf!

    startTurn: (turn) =>
        super(turn)

    -- planning
    plan: (time) =>
        super(time)
        @hasFinishedPlanning = true

    onThink: (dt) =>
        super(dt)

    executePlan: =>
        super!
        if (not @attack!)
            @move(@attackDirection.x, @attackDirection.y)


    -- attack
    attack: =>
        attackedCell = @neighborCell(@attackDirection.x, @attackDirection.y)

        if (attackedCell == nil)
            return false

        if (attackedCell.thing != nil or not attackedCell.walkable)
            @attacked = attackedCell.thing

            attackX = @x + @attackDirection.x * @attackMoveDistance
            attackY = @y + @attackDirection.y * @attackMoveDistance
            @attackTween = Tween.new(.2, @, { x: attackX, y: attackY }, "inCubic")
            @playingAttackTween = true
            return true

        return false


    -- collision
    onCollideThing: (thing) =>
        switch (thing.__class.__parent.__name)
            when "Player"
                -- attack
                @attack!
                return true

        return true
