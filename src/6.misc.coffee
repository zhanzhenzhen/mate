Object.isObject = (x) -> typeof x in ["object", "function"] and x != null
Object.isNormalObject = (x) -> Object.isObject(x) and typeof x != "function" and not Array.isArray(x)
# TODO: need to use new concept
Object.clone = (x) ->
    y = {}
    for key in Object.keys(x)
        y[key] = x[key]
    y
Object.allKeys = (x) -> key for key of x
Object.keyValues = (x) -> Object.keys(x).map((key) -> [key, x[key]])
Object.allKeyValues = (x) -> Object.allKeys(x).map((key) -> [key, x[key]])
Object.forEach = (x, callback) -> Object.keys(x).forEach((key) -> callback(key, x[key]))
Object.forEachOfAll = (x, callback) -> Object.allKeys(x).forEach((key) -> callback(key, x[key]))
Object.deepAssign = (target, sources...) ->
    sources.forEach((source) ->
        deepAssign = (target, source) ->
            Object.forEach(source, (key, value) ->
                if Object.isObject(target[key]) and Object.isObject(value)
                    deepAssign(target[key], value)
                else
                    target[key] = value
            )
        deepAssign(target, source)
    )
    target
Object.absorb = (subject, objects...) ->
    objects.forEach((object) ->
        Object.forEach(object, (key, value) -> subject[key] = value if subject[key] == undefined)
    )
    subject
Object.deepAbsorb = (subject, objects...) ->
    objects.forEach((object) ->
        deepAbsorb = (subject, object) ->
            Object.forEach(object, (key, value) ->
                if Object.isObject(subject[key]) and Object.isObject(value)
                    deepAbsorb(subject[key], value)
                else
                    subject[key] = value if subject[key] == undefined
            )
        deepAbsorb(subject, object)
    )
    subject
Object.deepClone = (x) ->
    target = {}
    deepExtend = (target, source) ->
        Object.forEach(source, (key, value) ->
            if Object.isObject(value)
                target[key] = {}
                deepExtend(target[key], value)
            else
                target[key] = value
        )
    deepExtend(target, x)
JSON.clone = (x) -> JSON.parse(JSON.stringify(x))
Date::add = (x) -> # `x` must be a number
    new Date(@ - (-x))
Date::subtract = (x) -> # `x` can be a number or `Date` instance
    if typeof x == "number"
        new Date(@ - x)
    else
        @ - x
Date::equals = (x) -> x <= @ <= x
console.logt = -> console.log.apply(console, [new Date().toISOString()].concat(Array.from(arguments)))
