export class FlowerEnemy extends Enemy
    new: =>
        super(1)

        with @graphic = Animation("#{Settings.folders.graphics}/flower.png", 20, 27)
            .origin.x = 13
            .origin.y = 18
            \addTrack("alive", "1-4", 130)\loop()
            \addTrack("attack", "5-10", 130)\onEnd( ->
                @releaseShoot!
                @graphic\play("alive")
                @finishTurn!
            )
            \addTrack("death", "11-20", 130)
            \play("alive")

        @attackRange = {}

        -- attack
        @damage = 1
        @performingAttack = false
        @shoot = nil
        @shootDirection = x: 0, y: 0
        @closeAttack = false
        @waitTurnsToAttack = 1

        -- attack tween
        @attackTween = nil
        @playingAttackTween = false
        @attackTweenDir = 1
        @attackMoveDistance = 14

    sceneAdded: (scene) =>
        super(scene)
        findRangeDir = {
            {  0, -1 }
            {  1,  0 }
            {  0,  1 }
            { -1,  0 }
        }

        local cell, cx, cy
        for _, dir in pairs findRangeDir
            cx = dir[1]
            cy = dir[2]
            cell = @neighborCell(cx, cy)

            while cell != nil and cell\isEmpty!
                Lume.push(@attackRange, { cx, cy })
                cx += dir[1]
                cy += dir[2]
                cell = @neighborCell(cx, cy)


    -- health
    onDeath: =>
        super!
        @graphic\play("death")

    -- planning
    plan: (time) =>
        super(time)

        if (@shoot != nil and @shoot.isAlive)
            @hasFinishedPlanning = true
            return false

        -- prepare attack
        playerCell =
            x: @scene.player.currentGrid.x
            y: @scene.player.currentGrid.y

        if (not @isLineOfSightVisibleTo(playerCell.x, playerCell.y))
            print "not visible"
            @hasFinishedPlanning = true
            @waitTurnsToAttack = 1
            return false

        if (@waitTurnsToAttack > 0)
            @waitTurnsToAttack -= 1
            @hasFinishedPlanning = true
            return

        @performingAttack = true
        dirToPlayerCell = @dirToCell(playerCell.x, playerCell.y)
        @shootDirection.x = dirToPlayerCell.x
        @shootDirection.y = dirToPlayerCell.y

        @hasFinishedPlanning = true
        return true

    onThink: (dt) =>
        super(dt)

    executePlan: =>
        super!
        if (@performingAttack and (@shootDirection.x != 0 or @shootDirection.y != 0))
            @attack(@shootDirection.x, @shootDirection.y)
            @waitTurnsToAttack = 1
        else
            @finishTurn!

    -- attack
    attack: (x, y) =>
        if (@shoot != nil and @shoot.isAlive)
            return false

        @graphic\play("attack")
        return true

    releaseShoot: =>
        Settings.audio.content.sfx["flowerAttack"]\play!
        @performingAttack = false
        gx, gy = @currentGrid.x + @shootDirection.x, @currentGrid.y + @shootDirection.y

        cell = @scene.grid\cellAt(gx, gy)
        if (cell != nil and not cell\isEmpty!)
            if (cell.thing != nil)
                switch (cell.thing.__class.__name)
                    when "Player"
                        cell.thing\takeDamage(@damage)
                    when "SeedBullet"
                        cell.thing\die!

            return

        with @shoot = SeedBullet!
            .attackDirection.x = @shootDirection.x
            .attackDirection.y = @shootDirection.y

        @scene.grid\addThingToCell(gx, gy, @shoot)
        print @shoot\toString!
