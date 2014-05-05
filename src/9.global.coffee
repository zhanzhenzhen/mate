if $mate.environmentType == "node"
    global.$mate = $mate
    global.compose = compose
    global.fail = fail
    global.assert = assert # Node.js has also an `assert` function but luckily it's not global
    global.repeat = repeat
    global.spread = spread
    global.cmath = cmath
    global.Point = Point
    global.EventField = EventField
    global.ObjectWithEvents = ObjectWithEvents
