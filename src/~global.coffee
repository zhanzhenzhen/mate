if exports? and module?.exports?
    global.$mate = $mate
    global.compose = compose
    global.fail = fail
    global.assert = assert # Node.js has also an `assert` function but luckily it's not global
    global.repeat = repeat
    global.spread = spread
    global.setAdvancedInterval = setAdvancedInterval
    global.clearAdvancedInterval = clearAdvancedInterval
    global.cmath = cmath
    global.Point = Point
    global.ObjectWithEvents = ObjectWithEvents