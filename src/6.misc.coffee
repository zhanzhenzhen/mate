Object.isObject = (x) -> typeof x in ["object", "function"] and x != null
Object.isNormalObject = (x) -> Object.isObject(x) and typeof x != "function" and not Array.isArray(x)
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
        assign = (target, source) ->
            Object.forEach(source, (key, value) ->
                if Object.isObject(value)
                    assign(target[key], value)
                else
                    target[key] = value
            )
        assign(target, source)
    )
    target
Object.absorb = (subject, objects...) ->
    objects.forEach((object) ->
        Object.forEach(object, (key, value) -> subject[key] = value if subject[key] == undefined)
    )
    subject
Object.deepAbsorb = (subject, objects...) ->
    objects.forEach((object) ->
        absorb = (subject, object) ->
            Object.forEach(object, (key, value) ->
                if Object.isObject(value)
                    absorb(subject[key], value)
                else
                    subject[key] = value if subject[key] == undefined
            )
        absorb(subject, object)
    )
    subject
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
