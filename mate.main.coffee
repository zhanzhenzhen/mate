compose = (functions) ->
    if arguments.length > 1 then functions = Array.from(arguments)
    ->
        args = arguments
        for m in functions
            args = [m.apply(@, args)]
        args[0]
fail = (errorMessage) -> throw new Error(errorMessage)
assert = (condition, message) -> if not condition then fail(message)
# Why `iterator` is the last argument: If not, parentheses must be added in practical use.
repeat = (times, iterator) ->
    iterator() for i in [0...times]
spread = (value, count) ->
    value for i in [0...count]
Object.getter = (obj, prop, fun) -> Object.defineProperty(obj, prop, {get: fun, configurable: true})
Object.setter = (obj, prop, fun) -> Object.defineProperty(obj, prop, {set: fun, configurable: true})
Object.clone = (x) ->
    y = {}
    for key in Object.keys(x)
        y[key] = x[key]
    y
JSON.clone = (x) -> JSON.parse(JSON.stringify(x))
Number.parseFloatExt = (s) -> parseFloat(s) * (if s.endsWith("%") then 0.01 else 1)
Math.radiansToDegrees = (radians) ->
    d = radians / Math.PI * 180
    rd = Math.round(d)
    # Prevent approximation if degree should be an integer.
    if Math.abs(d - rd) < 0.0001 then rd else d
Math.degreesToRadians = (degrees) -> degrees / 180 * Math.PI
# Returns a random number x where m<=x<n.
Math.randomNumber = (m, n) -> if m < n then m + Math.random() * (n - m) else fail()
# If n is omitted, returns a random integer x where 0<=x<m.
# If n is not omitted, Returns a random integer x where m<=x<n.
Math.randomInt = (m, n) ->
    min = if n == undefined then 0 else m
    max = if n == undefined then m else n
    Math.floor(Math.randomNumber(min, max))
# Better than the built-in regular expression method when global mode
# and submatches are both required.
# It always uses global mode and returns an array of arrays if any matches are found.
# If not, it returns an empty array.
String::matches = (regex) ->
    adjustedRegex = new RegExp(regex.source, "g")
    result = []
    loop
        match = adjustedRegex.exec(@)
        if match?
            result.push(match)
        else
            break
    result
String::capitalize = ->
    # use `charAt[0]` instead of `[0]` because `[0]` will return undefined if string is empty.
    @charAt(0).toUpperCase() + @substr(1)
class ObjectWithEvents
    constructor: ->
        @_eventList = {} # Using object to simulate a "dictionary" here is simpler than using array.
    on: (eventName, listener) ->
        @_eventList[eventName] ?= []
        @_eventList[eventName].push(listener) if listener not in @_eventList[eventName]
    off: (eventName, listener) -> @_eventList[eventName].removeAll(listener)
    trigger: (eventName, arg) ->
        @_eventList[eventName] ?= []
        m(arg) for m in @_eventList[eventName]
    listeners: (eventName) -> @_eventList[eventName]
