export class Movement extends Component
    new: (maxVelocityX, maxVelocityY, accelerationX, accelerationY) =>
        super!

        -- axis
        @lastAxis = x: 0, y: 0
        @axis = x: 0, y: 0
        @nextAxis = x: 0, y: 0
        @snapaxes = true

        -- velocity
        @velocity = x: 0, y: 0
        @maxVelocity = x: maxVelocityX, y: maxVelocityY
        @targetVelocity = x: 0, y: 0
        @acceleration = x: accelerationX, y: accelerationY
        @dampening = 6

    beforeUpdate: =>
        super!
        if (@axis.x != 0 or @axis.y != 0)
            @lastAxis.x = @axis.x
            @lastAxis.y = @axis.y

        @axis.x = @nextAxis.x
        @axis.y = @nextAxis.y
        @targetVelocity.x = Math.sign(@axis.x) * @maxVelocity.x
        @targetVelocity.y = Math.sign(@axis.y) * @maxVelocity.x
        @nextAxis.x = 0
        @nextAxis.y = 0

    update: (dt) =>
        super(dt)

        -- horizontal
        if (@axis.x == 0)
            @velocity.x = Math.approach(@velocity.x, 0, @maxVelocity.x * @dampening * dt)
        elseif (@snapaxes and @velocity.x != 0 and Math.sign(@axis.x) != Math.sign(@velocity.x))
            @velocity.x = 0
        else
            @velocity.x = Math.approach(@velocity.x, @targetVelocity.x, @acceleration.x * dt)

        @entity.x += @velocity.x * dt

        -- vertical
        if (@axis.y == 0)
            @velocity.y = Math.approach(@velocity.y, 0, @maxVelocity.y * @dampening * dt)
        elseif (@snapaxes and @velocity.y != 0 and Math.sign(@axis.y) != Math.sign(@velocity.y))
            @velocity.y = 0
        else
            @velocity.y = Math.approach(@velocity.y, @targetVelocity.y, @acceleration.y * dt)

        @entity.y += @velocity.y * dt

    moveX: (x) =>
        @nextAxis.x = x

    moveY: (y) =>
        @nextAxis.y = y

    move: (x, y) =>
        @moveX(x)
        @moveY(y)

    toString: =>
        "axis: #{@axis.x}, #{@axis.y}
velocity: #{@velocity.x}, #{@velocity.y}
    max: #{@maxVelocity.x}, #{@maxVelocity.y}
    target: #{@targetVelocity.x}, #{@targetVelocity.y}
acc: #{@acceleration.x}, #{@acceleration.y}"
