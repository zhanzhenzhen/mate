# This file must NOT depend on any other parts of the project, because this file
# will be used to test other parts.
# Otherwise the test result may be incorrect.

if not (typeof $mate == "object" and $mate != null)
    $mate = {}
$mate.testing = {}
class $mate.testing.Test
    constructor: (@description = "") ->
        @_children = []
        @_fun = null
        @_ended = false
        @_async = false
        @parent = null
        @unitResults = []
        @result = null
    set: (fun) ->
        @_fun = fun
        @
    get: ->
        @_fun
    add: (description, fun) ->
        if typeof description != "string"
            fun = description
            description = ""
        else
            description ?= ""
        newChild = new $mate.testing.Test(description).set(fun)
        newChild.parent = @
        @_children.push(newChild)
        @
    addAsync: (description, fun) ->
        @add(description, fun)
        @_async = true
        @
    getChildren: ->
        # use a shallow copy to encapsule `_children` to prevent direct operation on the array
        @_children[..]
    getAncestors: ->
        test = @
        r = []
        while test.parent != null
            r.push(test.parent)
            test = test.parent
        r
    run: (showsMessage = true) ->
        startTime = new Date()
        if @_fun?
            setTimeout(=>
                doTest = =>
                    @_fun(@)
                    if not @_async then @end()
                if exports? and module?.exports?
                    domain = require("domain").create()
                    domain.on("error", (error) =>
                        @result =
                            type: false
                            errorMessage: """
                                Error Name: #{error.name}
                                Error Message: #{error.message}
                                Error Stack: #{error.stack}
                            """
                        @end()
                    )
                    domain.run(doTest)
                else
                    try
                        doTest()
                    catch
                        @result =
                            type: false
                        @end()
            , 0)
        @getChildren().forEach((m) -> m.run(false))
        if showsMessage
            allTests = []
            traverse = (test) =>
                test.getChildren().forEach((m) ->
                    allTests.push(m)
                    traverse(m)
                )
            traverse(@)
            console.log()
            # TODO: Scanning for timeout is now also in this function. It's inaccurate because interval
            # is 1 sec. We may need to create another timer with shorter interval for that.
            timerJob = =>
                time = new Date()
                okTests = allTests.filter((m) => m.result? and m.result.type == true)
                exceptionTests = allTests.filter((m) => m.result? and m.result.type == false)
                pendingTests = allTests.filter((m) => not m.result?)
                console.log("#{new Date().toISOString()} OK: #{okTests.length}, " +
                        "Exception: #{exceptionTests.length}, Pending: #{pendingTests.length}")
                if pendingTests.length == 0
                    clearInterval(timer)
                    exceptionTests.forEach((m) =>
                        console.log("\n********** Exceptional Test **********")
                        console.log("Test: #{m.description}")
                        console.log("Function: #{m.get().toString()}")
                        console.log(m.result.errorMessage) if m.result.errorMessage?
                    )
                    failureCount = 0
                    allTests.forEach((m) =>
                        m.unitResults.filter((m) -> m.type == false).forEach((n, index) ->
                            failureCount++
                            console.log("\n********** Failed Unit **********")
                            console.log("Test: #{m.getAncestors().map((m) -> m.description).join(" --> ")}")
                            console.log("Unit: #{n.description}")
                            console.log("Index: #{index}")
                            console.log(n.description)
                        )
                    )
                    console.log("\n" + (
                        if exceptionTests.length == 0 and failureCount == 0
                            "Completed. All tests are OK. All units succeeded."
                        else
                            "Completed. #{exceptionTests.length} exceptional tests. " +
                                    "#{failure.length} failed units."
                    ) + "\n")
                    process.exit() if process?
            timer = setInterval(timerJob, 1000)
            setTimeout(timerJob, 0)
        @
    end: ->
        @_ended = true
        @
    equal: (actual, expected, description = "") ->
        @unitResults.push(
            type: actual == expected
            description: description
        )
        @
