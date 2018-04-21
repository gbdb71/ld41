export class Movement extends Component
    new: (maxVelocityX, maxVelocityY, accelerationX, accelerationY) =>
        super!

        -- axis
        @lastAxis = x: 0, y: 0
        @axis = x: 0, y: 0
        @nextAxis = x: 0, y: 0
        @snapaxes = true

        -- position
        @hasTargetPosition = false
        @targetPosition = x: 0, y: 0

        -- velocity
        @velocity = x: 0, y: 0
        @maxVelocity = x: maxVelocityX, y: maxVelocityY
        @targetVelocity = x: 0, y: 0
        @acceleration = x: accelerationX, y: accelerationY

        -- others
        @dampening = 10

    beforeUpdate: =>
        super!

    update: (dt) =>
        super(dt)

        if (@hasTargetPosition)
            angle = Lume.angle(@entity.x, @entity.y, @targetPosition.x, @targetPosition.y)
            @nextAxis.x, @nextAxis.y = Lume.vector(angle, 1)

        if (@axis.x != 0 or @axis.y != 0)
            @lastAxis.x = @axis.x
            @lastAxis.y = @axis.y

        @axis.x = @nextAxis.x
        @axis.y = @nextAxis.y
        @targetVelocity.x = @axis.x * @maxVelocity.x
        @targetVelocity.y = @axis.y * @maxVelocity.x
        @nextAxis.x = 0
        @nextAxis.y = 0

        -- horizontal
        if (@axis.x == 0)
            @velocity.x = Math.approach(@velocity.x, 0, @maxVelocity.x * @dampening * dt)
        elseif (@snapaxes and @velocity.x != 0 and Math.sign(@axis.x) != Math.sign(@velocity.x))
            @velocity.x = 0
        else
            @velocity.x = Math.approach(@velocity.x, @targetVelocity.x, @acceleration.x * dt)

        displacementX = @velocity.x * dt

        -- vertical
        if (@axis.y == 0)
            @velocity.y = Math.approach(@velocity.y, 0, @maxVelocity.y * @dampening * dt)
        elseif (@snapaxes and @velocity.y != 0 and Math.sign(@axis.y) != Math.sign(@velocity.y))
            @velocity.y = 0
        else
            @velocity.y = Math.approach(@velocity.y, @targetVelocity.y, @acceleration.y * dt)

        displacementY = @velocity.y * dt

        -- resolution
        if (@hasTargetPosition)
            if (@entity.x != @targetPosition.x)
                if (@entity.x < @targetPosition.x)
                    @entity.x = math.min(@entity.x + displacementX, @targetPosition.x)
                else
                    @entity.x = math.max(@entity.x + displacementX, @targetPosition.x)

            if (@entity.y != @targetPosition.y)
                if (@entity.y < @targetPosition.y)
                    @entity.y = math.min(@entity.y + displacementY, @targetPosition.y)
                else
                    @entity.y = math.max(@entity.y + displacementY, @targetPosition.y)

            if (@entity.x == @targetPosition.x and @entity.y == @targetPosition.y)
                @hasTargetPosition = false
                @nextAxis.x = 0
                @nextAxis.y = 0
                @velocity.x = 0
                @velocity.y = 0
        else
            @entity.x += displacementX
            @entity.y += displacementY

    moveX: (x) =>
        @nextAxis.x = x

    moveY: (y) =>
        @nextAxis.y = y

    move: (x, y) =>
        @moveX(x)
        @moveY(y)

    moveTo: (x, y) =>
        @hasTargetPosition = true
        @targetPosition.x = x
        @targetPosition.y = y

    toString: =>
        "axis: #{@axis.x}, #{@axis.y}
velocity: #{@velocity.x}, #{@velocity.y}
    max: #{@maxVelocity.x}, #{@maxVelocity.y}
    target: #{@targetVelocity.x}, #{@targetVelocity.y}
acc: #{@acceleration.x}, #{@acceleration.y}"
