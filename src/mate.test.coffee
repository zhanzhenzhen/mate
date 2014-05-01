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
            # Note:
            # `state` and `result` are similar but slightly different. Users should
            # not change `result`. Once `result` is set to true or false automatically by mate,
            # it should not be rolled back to undefined. This mechanism is to prevent the
            # "success" and "failure" numbers from being decreased (if one changes the `state` back).
            # Also Note:
            # `result`'s initial value is undefined but `state`'s initial value is null.
            # Why? Because `state` can be tweaked by user. If it's initially undefined,
            # then it is to be "created", not "changed" or "tweaked",
            # which slightly looks like a bad style in designing the interface.
            contexts: testFunctions.map((m) =>
                name: name
                fun: m
                state: null
            )
            delay: delay
            timeout: timeout
        @
    run: ->
        startTime = new Date()
        Object.keys(@_list).forEach((name) =>
            item = @_list[name]
            item.contexts.forEach((context) =>
                setTimeout(=>
                    match = context.fun.toString().match(/function *\(([^)]*)\)/)
                    isAsync = match? and match[1].trim().length > 0
                    domain = require("domain").create()
                    domain.on("error", (error) =>
                        context.state = false
                        context.errorMessage = error.stack
                    )
                    domain.run(=>
                        if isAsync
                            context.fun(context)
                        else
                            if context.fun() != false
                                context.state = true
                            else
                                context.state = false
                    )
                , item.delay)
            )
        )
        console.log()
        # TODO: Scanning for timeout is now also in this function. It's inaccurate because interval
        # is 1 sec. We may need to create another timer with shorter interval for that.
        timer = setAdvancedInterval((time) =>
            all = []
            Object.keys(@_list).forEach((name) =>
                item = @_list[name]
                item.contexts.forEach((m) =>
                    if not m.result?
                        if time.subtract(startTime) > @timeout or
                                time.subtract(startTime.add(item.delay)) > item.timeout
                            m.result = false
                        else if m.state?
                            m.result = m.state
                    all.push(m)
                )
            )
            success = all.filter((m) => m.result == true)
            failure = all.filter((m) => m.result == false)
            pending = all.filter((m) => m.result != true and m.result != false)
            console.logt("Success: #{success.length}, Failure: #{failure.length}, " +
                    "Pending: #{pending.length}")
            if pending.length == 0
                clearAdvancedInterval(timer)
                failure.forEach((m) =>
                    console.log("\nFailure \"#{m.name}\":")
                    console.log(m.fun.toString())
                    console.log(m.errorMessage) if m.errorMessage?
                )
                console.log("\n" + (
                    if failure.length == 0
                        "Completed. All succeeded."
                    else
                        "Completed. #{failure.length} failures."
                ) + "\n")
                process.exit()
        , 1000)
        @
    timeout: 86400000
    _list: {}
    _defaultNameCounter: 0
