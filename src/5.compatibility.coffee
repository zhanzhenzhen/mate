# This file provides compatibility among various browsers and server-side platforms such as node.
# It also brings some ECMAScript 6 features (considered as "future compatibility").

featureLoaders.push(->
    # This is in ECMAScript 6. Only Firefox natively supports this.
    if Number.EPSILON == undefined
        Number.EPSILON = 2.2204460492503130808472633361816e-16
    # This is in ECMAScript 6. Only Firefox natively supports this.
    if Number.isInteger == undefined
        Number.isInteger = (x) ->
            typeof x == "number" and isFinite(x) and x > -9007199254740992 and
                    x < 9007199254740992 and Math.floor(x) == x
    # This is in ECMAScript 6. Only Firefox natively supports this.
    if String::startsWith == undefined
        String::startsWith = (s) -> @indexOf(s) == 0
    # This is in ECMAScript 6. Only Firefox natively supports this.
    if String::endsWith == undefined
        String::endsWith = (s) -> @lastIndexOf(s) == @length - s.length
    # This is in ECMAScript 6. Only Firefox natively supports this.
    if String::contains == undefined
        String::contains = (s) -> @indexOf(s) != -1
    # This is in ECMAScript 6. Only Firefox and Chrome natively supports this.
    if Object.is == undefined
        Object.is = (a, b) ->
            if typeof a == "number" and typeof b == "number"
                if a == 0 and b == 0
                    1 / a == 1 / b
                else if isNaN(a) and isNaN(b)
                    true
                else
                    a == b
            else
                a == b
    # This is in ECMAScript 6. No browser natively supports this.
    if Array.from == undefined
        Array.from = (arrayLike) -> m for m in arrayLike
    # This is in ECMAScript 6. No browser natively supports this.
    # TODO: performance
    if Array::find == undefined
        Array::find = (predicate) ->
            assert(typeof predicate == "function")
            found = @filter(predicate)
            if not found.isEmpty()
                found.at(0)
            else
                undefined
    # This is in ECMAScript 6. No browser natively supports this.
    # TODO: performance
    if Array::findIndex == undefined
        Array::findIndex = (predicate) ->
            element = @find(predicate)
            if element == undefined then -1 else @indexOf(element)
    # This is in ECMAScript 6. Only Firefox natively supports this.
    if Math.sign == undefined
        Math.sign = (x) ->
            if typeof x == "number"
                if x == 0
                    0
                else if x > 0
                    1
                else if x < 0
                    -1
                else
                    NaN
            else
                NaN
    # Only IE natively supports this.
    if global.setImmediate == undefined
        global.setImmediate = (callback, args) -> setTimeout(callback, 0, args)
    # Only IE natively supports this.
    if global.clearImmediate == undefined
        global.clearImmediate = clearTimeout
)
