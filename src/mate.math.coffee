# Many degree methods and radian methods are independent, to avoid degrees approximation.

# Useful when come across a computed value like 179.9999999. [
Math.nearlyEquals = (a, b) ->
    threshold = 1 + 1 / 65536
    1 / threshold < a / b < threshold
Math.nearlyGreaterThan = (a, b) -> a > b or Math.nearlyEquals(a, b)
Math.nearlyLessThan = (a, b) -> a < b or Math.nearlyEquals(a, b)
# ]
Math.radiansToDegrees = (radians) -> radians / Math.PI * 180
Math.degreesToRadians = (degrees) -> degrees / 180 * Math.PI
Math.principalRadians = (radians) ->
    t = radians % (2 * Math.PI)
    if t <= -Math.PI
        t + 2 * Math.PI
    else if t > Math.PI
        t - 2 * Math.PI
    else
        t
Math.principalDegrees = (degrees) ->
    t = degrees % 360
    if t <= -180
        t + 360
    else if t > 180
        t - 360
    else
        t
# Returns a random number x where m<=x<n.
Math.randomNumber = (m, n) -> if m < n then m + Math.random() * (n - m) else fail()
# If n is omitted, returns a random integer x where 0<=x<m.
# If n is not omitted, Returns a random integer x where m<=x<n.
Math.randomInt = (m, n) ->
    min = if n == undefined then 0 else m
    max = if n == undefined then m else n
    Math.floor(Math.randomNumber(min, max))
Number::nearlyEquals = (x) -> Math.nearlyEquals(@, x)
Number::nearlyGreaterThan = (x) -> Math.nearlyGreaterThan(@, x)
Number::nearlyLessThan = (x) -> Math.nearlyLessThan(@, x)
# This class is a combination of 3 things: complex number, 2d point, and 2d vector.
# It can even be used for all "ordered pair" things such as size (width and height).
class Point
    constructor: (@x, @y) ->
    @from: (value) ->
        if typeof value == "number"
            new Point(value, 0)
        else if value instanceof Point
            value.clone()
        else if typeof value == "string"
            Point.fromString(value)
        else if Array.isArray(value)
            Point.fromArray(value)
        else
            fail()
    @fromArray: (array) -> new Point(array[0], array[1])
    @fromString: (s) ->
        adjustedString = s.replace(/// [ \x20 ( ) ] ///g, "")
        normalMatch = adjustedString.match(///^ ([^,]*) , (.*) $///)
        if normalMatch?
            new Point(
                Number.parseFloatExt(normalMatch[1]),
                Number.parseFloatExt(normalMatch[2])
            )
        else
            complexMatch = adjustedString.match(///^
                (
                    [+-]?
                    [0-9]*
                    \.?
                    [0-9]*
                    (?:
                        [Ee]
                        [+-]?
                        [0-9]+
                    )?
                    (?! [i0-9Ee.] )
                )?
                (?:
                    (
                        [+-]?
                        [0-9]*
                        \.?
                        [0-9]*
                        (?:
                            [Ee]
                            [+-]?
                            [0-9]+
                        )?
                    )
                    i
                )?
            $///)
            if complexMatch?
                real = complexMatch[1] ? "0"
                imaginary = complexMatch[2] ? "0"
                if real == "" then real = "1"
                if imaginary == "" then imaginary = "1"
                if real == "+" then real = "1"
                if imaginary == "+" then imaginary = "1"
                if real == "-" then real = "-1"
                if imaginary == "-" then imaginary = "-1"
                new Point(
                    parseFloat(real),
                    parseFloat(imaginary)
                )
            else
                fail()
    @fromPolar: (r, angle) -> new Point(r * Math.cos(angle), r * Math.sin(angle))
    @fromPolarInDegrees: (r, angle) -> switch Math.principalDegrees(angle)
        # avoid approximation [
        when 0 then new Point(r, 0)
        when 90 then new Point(0, r)
        when -90 then new Point(0, -r)
        when 180 then new Point(-r, 0)
        # ]
        else Point.fromPolar(r, Math.degreesToRadians(angle))
    real: -> @x
    imaginary: -> @y
    toString: -> "(#{@x},#{@y})"
    toComplexString: ->
        sign = if @y >= 0 then "+" else "-"
        "#{@x}#{sign}#{Math.abs(@y)}i"
    clone: -> new Point(@x, @y)
    equals: (p) -> cmath.equals(@, p)
    nearlyEquals: (p) -> cmath.nearlyEquals(@, p)
    opposite: -> cmath.opposite(@)
    reciprocal: -> cmath.reciprocal(@)
    conjugate: -> cmath.conjugate(@)
    abs: -> cmath.abs(@)
    add: (p) -> cmath.add(@, p)
    subtract: (p) -> cmath.subtract(@, p)
    multiply: (p) -> cmath.multiply(@, p)
    divide: (p) -> cmath.divide(@, p)
    distance: (p) -> cmath.distance(@, p)
    dotProduct: (p) ->
        p = Point.from(p)
        @x * p.x + @y * p.y
    # There's no need to return the direction, because the direction is certain
    # and not in x-y plane.
    crossProduct: (p) ->
        p = Point.from(p)
        @x * p.y - @y * p.x
    isOppositeTo: (p) -> @opposite().equals(p)
    phase: -> cmath.phase(@)
    phaseTo: (p) ->
        p = Point.from(p)
        Math.principalRadians(p.phase() - @phase())
    phaseInDegrees: -> cmath.phaseInDegrees(@)
    phaseInDegreesTo: (p) ->
        p = Point.from(p)
        Math.principalDegrees(p.phaseInDegrees() - @phaseInDegrees())
    scale: (size) ->
        size = Point.from(size)
        new Point(@x * size.x, @y * size.y)
    rotate: (angle) -> @multiply(Point.fromPolar(1, angle))
    rotateDegrees: (angle) -> @multiply(Point.fromPolarInDegrees(1, angle))
# There are not any `Point`'s non-static methods here. This is to
# avoid circular calling.
# Also, 2d vector related things are not written here. They may be in `Point`.
cmath =
    equals: (a, b) ->
        a = Point.from(a)
        b = Point.from(b)
        a.x == b.x and a.y == b.y
    nearlyEquals: (a, b) ->
        a = Point.from(a)
        b = Point.from(b)
        a.x.nearlyEquals(b.x) and a.y.nearlyEquals(b.y)
    opposite: (p) ->
        p = Point.from(p)
        new Point(-p.x, -p.y)
    reciprocal: (p) ->
        p = Point.from(p)
        n = p.x * p.x + p.y * p.y
        new Point(p.x / n, -p.y / n)
    conjugate: (p) ->
        p = Point.from(p)
        new Point(p.x, -p.y)
    abs: (p) ->
        p = Point.from(p)
        # If on x-axis or y-axis, then it doesn't calculate square root.
        # This is not for performance, but for preventing approximation.
        # Though all modern browsers already don't generate approximations,
        # we make it even much safer.
        if p.x == 0
            Math.abs(p.y)
        else if p.y == 0
            Math.abs(p.x)
        else
            Math.sqrt(p.x * p.x + p.y * p.y)
    phase: (p) -> # We use `phase` instead of `argument` to avoid ambiguity.
        p = Point.from(p)
        Math.atan2(p.y, p.x)
    phaseInDegrees: (p) ->
        p = Point.from(p)
        # avoid approximation [
        if p.x == 0 and p.y == 0
            0
        else if p.x == 0 and p.y > 0
            90
        else if p.x == 0 and p.y < 0
            -90
        else if p.x > 0 and p.y == 0
            0
        else if p.x < 0 and p.y == 0
            180
        # ]
        else
            d = Math.radiansToDegrees(cmath.phase(p))
            if d <= -180
                180
            else
                d
    add: (a, b) ->
        a = Point.from(a)
        b = Point.from(b)
        new Point(a.x + b.x, a.y + b.y)
    subtract: (a, b) -> cmath.add(a, cmath.opposite(b))
    multiply: (a, b) ->
        a = Point.from(a)
        b = Point.from(b)
        new Point(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x)
    divide: (a, b) -> cmath.multiply(a, cmath.reciprocal(b))
    distance: (a, b) -> cmath.abs(cmath.subtract(a, b))
    exp: (p) ->
        p = Point.from(p)
        Point.fromPolar(Math.exp(p.x), p.y)
    log: (p) -> new Point(Math.log(cmath.abs(p)), cmath.phase(p))
    pow: (a, b) -> cmath.exp(cmath.multiply(cmath.log(a), b))
    sqrt: (p) ->
        p = Point.from(p)
        r = cmath.abs(p)
        new Point(Math.sqrt((r + p.x) / 2), Math.sign(p.y) * Math.sqrt((r - p.x) / 2))
    cos: (p) ->
        cmath.divide(
            cmath.add(
                cmath.exp(
                    cmath.multiply(p, new Point(0, 1))
                ),
                cmath.exp(
                    cmath.multiply(
                        cmath.opposite(p), new Point(0, 1)
                    )
                )
            ),
            2
        )
    sin: (p) ->
        cmath.divide(
            cmath.subtract(
                cmath.exp(
                    cmath.multiply(p, new Point(0, 1))
                ),
                cmath.exp(
                    cmath.multiply(
                        cmath.opposite(p), new Point(0, 1)
                    )
                )
            ),
            new Point(0, 2)
        )
    tan: (p) -> cmath.divide(cmath.sin(p), cmath.cos(p))
    acos: (p) ->
        cmath.opposite(
            cmath.multiply(
                cmath.log(
                    cmath.add(
                        p,
                        cmath.multiply(
                            cmath.sqrt(
                                cmath.add(
                                    cmath.opposite(
                                        cmath.multiply(p, p)
                                    ),
                                    1
                                )
                            ),
                            new Point(0, 1)
                        )
                    )
                ),
                new Point(0, 1)
            )
        )
    asin: (p) ->
        cmath.opposite(
            cmath.multiply(
                cmath.log(
                    cmath.add(
                        cmath.multiply(p, new Point(0, 1)),
                        cmath.sqrt(
                            cmath.add(
                                cmath.opposite(
                                    cmath.multiply(p, p)
                                ),
                                1
                            )
                        )
                    )
                ),
                new Point(0, 1)
            )
        )
    atan: (p) ->
        cmath.multiply(
            cmath.subtract(
                cmath.log(
                    cmath.subtract(
                        1,
                        cmath.multiply(p, new Point(0, 1))
                    )
                ),
                cmath.log(
                    cmath.add(
                        1,
                        cmath.multiply(p, new Point(0, 1))
                    )
                )
            ),
            new Point(0, 0.5)
        )