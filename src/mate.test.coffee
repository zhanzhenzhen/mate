$mate.test =
    add: (name, testFunctions, delay, timeout) ->
        if typeof name != "string"
            timeout = delay
            delay = testFunctions
            testFunctions = name
            name = "Test_#{@_defaultNameCounter}"
            @_defaultNameCounter++
        if typeof testFunctions == "function"
            testFunctions = [testFunctions]
        delay ?= 0
        timeout ?= 86400000
        @_list[name] =
            body: testFunctions.map((m) => {fun: m, state: null})
            delay: delay
            timeout: timeout
    run: ->
        Object.keys(@_list).forEach((name) =>
            item = @_list[name]
            item.body.forEach((m) =>
                setTimeout(=>
                    match = m.fun.toString().match(/function *\(([^)]*)\)/)
                    isAsync = match? and match[1].trim().length > 0
                    domain = require("domain").create()
                    domain.on("error", =>
                        m.state = false
                    )
                    domain.run(=>
                        if isAsync
                            m.fun(m)
                        else
                            if m.fun() != false
                                m.state = true
                            else
                                m.state = false
                    )
                , item.delay)
            )
        )
        timer = setAdvancedInterval(=>
            totalCount = 0
            result = []
            Object.keys(@_list).forEach((name) =>
                item = @_list[name]
                item.body.forEach((m) =>
                    totalCount++
                    if m.state? then result.push(
                        type: m.state
                        name: name
                        message: m.fun.toString()
                    )
                )
            )
            success = result.filter((m) -> m.type == true)
            failure = result.filter((m) -> m.type == false)
            console.logt("Success: #{success.length}, Failure: #{failure.length}, " +
                    "Unfinished: #{totalCount - success.length - failure.length}")
            if success.length + failure.length >= totalCount
                clearAdvancedInterval(timer)
                console.log("Completed.")
                failure.forEach((m) ->
                    console.log("\nFailure \"#{m.name}\":")
                    console.log(m.message)
                )
        , 1000)
    _list: {}
    _defaultNameCounter: 0
