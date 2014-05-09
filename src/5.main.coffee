compose = (functions) ->
    if arguments.length > 1 then functions = Array.from(arguments)
    ->
        args = arguments
        for m in functions
            args = [m.apply(@, args)]
        args[0]
fail = (errorMessage) -> throw new Error(errorMessage)
assert = (condition, message) -> if not condition then fail(message)
# Can `spread` and `repeat` be combined into one function? No, because:
# If we combine them into one, then it cannot spread a function. [
repeat = (iterator, times) ->
    if typeof iterator == "number" then [times, iterator] = [iterator, times]
    iterator() for i in [0...times]
spread = (value, count) ->
    value for i in [0...count]
# ]
Object.getter = (obj, prop, fun) -> Object.defineProperty(obj, prop, {get: fun, configurable: true})
Object.setter = (obj, prop, fun) -> Object.defineProperty(obj, prop, {set: fun, configurable: true})
Object.clone = (x) ->
    y = {}
    for key in Object.keys(x)
        y[key] = x[key]
    y
JSON.clone = (x) -> JSON.parse(JSON.stringify(x))
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
    # Use `charAt[0]` instead of `[0]` because `[0]` will return undefined if string is empty.
    @charAt(0).toUpperCase() + @substr(1)
Date::add = (x) -> # `x` must be a number
    new Date(@ - (-x))
Date::subtract = (x) -> # `x` can be a number or `Date` instance
    if typeof x == "number"
        new Date(@ - x)
    else
        @ - x
Date::equals = (x) -> x <= @ <= x
console.logt = -> console.log.apply(null, [new Date().toISOString()].concat(Array.from(arguments)))
# I think `EventField` can do all that `ObjectWithEvents` can do, plus support for static events.
# And it can avoid using strings so `EventField` is better. But maybe others like `ObjectWithEvents`
# so I keep both.
# Why `EventField().fire` and `ObjectWithEvents::trigger`? Because although "fire" is simpler,
# it's a more frequently used word, so in `ObjectWithEvent` we should keep "fire" from occupying
# this naming space.
# [
# This function is weird and hard to understand, but we must use this mechanism
# (function+object hybrid) to support cascade (chaining).
EventField = ->
    f = (method, arg) ->
        if typeof method == "function"
            arg = method
            method = "bind"
        assert(typeof method == "string")
        f[method](arg)
        @
    f._listeners = []
    f.bind = (listener) ->
        f._listeners.push(listener) if listener not in f._listeners
        f
    f.unbind = (listener) ->
        f._listeners.removeAll(listener)
        f
    f.fire = (arg) ->
        for m in f._listeners
            if arg?.blocksListeners then break
            m(arg)
        undefined
    f
# Node.js uses `emit` but we use `trigger`. I guess why node.js uses that strange name is maybe
# only to avoid the name `EventTriggerer`.
class ObjectWithEvents
    constructor: ->
        @_eventList = {} # Using object to simulate a "dictionary" here is simpler than using array.
    on: (eventName, listener) ->
        @_eventList[eventName] ?= []
        @_eventList[eventName].push(listener) if listener not in @_eventList[eventName]
        @
    off: (eventName, listener) ->
        @_eventList[eventName].removeAll(listener)
        @
    trigger: (eventName, arg) ->
        @_eventList[eventName] ?= []
        m(arg) for m in @_eventList[eventName]
        undefined
    listeners: (eventName) -> @_eventList[eventName]
# ]
