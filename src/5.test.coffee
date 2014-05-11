# This file must NOT depend on any other parts of the project, because we will use it to test other parts.
# Otherwise the test result may be incorrect.

if not (typeof $mate == "object" and $mate != null)
    $mate = {}
# Why use object `test` instead of using static class `Test`?
# Answer is simple: for lowercase reason.
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
            contexts: testFunctions.map((m, index) =>
                # Why use embedded JavaScript? Because we want to use a JavaScript feature
                # "named function expression" which CoffeeScript does not support, like this:
                ###
                    [1,2,3,4,5].map(function factorial (n) {
                        return !(n > 1) ? 1 : factorial(n-1)*n;
                    });
                ###
                # See "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference
                # /Functions_and_function_scope/arguments/callee".
                # We cannot use `arguments.callee` because it's deprecated for strict mode
                # as mentioned in the above link.
                context =
                    name: name
                    index: index
                    fun: m
                    setState: `
                        function f(x) {
                            if (f.context._state !== true && f.context._state !== false) {
                                if (x !== true && x !== false) {
                                    x = true;
                                }
                                f.context._state = x;
                            }
                        }
                    `
                    getState: -> @_state
                    _state: null
                context.setState.context = context
                context
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
                    runFunction = =>
                        if isAsync
                            context.fun(context.setState)
                        else
                            if context.fun() != false
                                context.setState(true)
                            else
                                context.setState(false)
                    if exports? and module?.exports?
                        domain = require("domain").create()
                        domain.on("error", (error) =>
                            context.setState(false)
                            context.errorMessage = """
                                Error Name: #{error.name}
                                Error Message: #{error.message}
                                Error Stack: #{error.stack}
                            """
                        )
                        domain.run(runFunction)
                    else
                        try
                            runFunction()
                        catch
                            context.setState(false)
                , item.delay)
            )
        )
        console.log()
        # TODO: Scanning for timeout is now also in this function. It's inaccurate because interval
        # is 1 sec. We may need to create another timer with shorter interval for that.
        timerJob = =>
            time = new Date()
            all = []
            Object.keys(@_list).forEach((name) =>
                item = @_list[name]
                item.contexts.forEach((m) =>
                    if not m.getState()?
                        if time.getTime() - startTime.getTime() > @timeout or
                                time.getTime() - (startTime.getTime() + item.delay) > item.timeout
                            m.setState(false)
                    all.push(m)
                )
            )
            success = all.filter((m) => m.getState() == true)
            failure = all.filter((m) => m.getState() == false)
            pending = all.filter((m) => m.getState() != true and m.getState() != false)
            console.log("#{new Date().toISOString()} Success: #{success.length}, " +
                    "Failure: #{failure.length}, Pending: #{pending.length}")
            if pending.length == 0
                clearInterval(timer)
                failure.forEach((m) =>
                    console.log("\n********** Failure **********")
                    console.log("Name: #{m.name}")
                    console.log("Index: #{m.index}")
                    console.log("Function: #{m.fun.toString()}")
                    console.log(m.errorMessage) if m.errorMessage?
                )
                console.log("\n" + (
                    if failure.length == 0
                        "Completed. All succeeded."
                    else
                        "Completed. #{failure.length} failures."
                ) + "\n")
                process.exit() if process?
        timer = setInterval(timerJob, 1000)
        setTimeout(timerJob, 0)
        @
    timeout: 86400000
    _list: {}
    _defaultNameCounter: 0
