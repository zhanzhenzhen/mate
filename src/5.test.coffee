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
        @async = false
        @parent = null
        @unitResults = []
        @result = null
    set: (fun) ->
        @_fun = fun
        @
    get: ->
        @_fun
    add: (description, fun, async) ->
        if typeof description == "object"
            newChild = description
        else
            if typeof description != "string"
                async = fun ? false
                fun = description
                description = ""
            newChild = new $mate.testing.Test(description).set(fun)
            newChild.async = async
        newChild.parent = @
        @_children.push(newChild)
        @
    addAsync: (description, fun) ->
        @add(description, fun, true)
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
        if @_fun?
            # We use `setTimeout(..., 0)` only to make all tests "unordered", at least theoretically.
            setTimeout(=>
                doTest = =>
                    @_fun(@)
                    if not @async then @end(type: true)
                if exports? and module?.exports?
                    domain = require("domain").create()
                    domain.on("error", (error) =>
                        @end(
                            type: false
                            errorMessage: """
                                Error Name: #{error.name}
                                Error Message: #{error.message}
                                Error Stack: #{error.stack}
                            """
                        )
                    )
                    domain.run(doTest)
                else
                    try
                        doTest()
                    catch
                        @end(type: false)
            , 0)
        @getChildren().forEach((m) => m.run(false))
        if showsMessage
            allTests = []
            allTests.push(@) if @.get()?
            traverse = (test) =>
                test.getChildren().forEach((m) =>
                    allTests.push(m) if m.get()?
                    traverse(m)
                )
            traverse(@)
            console.log()
            # TODO: Scanning for timeout is now also in this function. It's inaccurate because interval
            # is 1 sec. We may need to create another timer with shorter interval for that.
            timerJob = =>
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
                        m.unitResults.filter((m) => m.type == false).forEach((n, index) =>
                            failureCount++
                            ancestors = m.getAncestors()
                            ancestors.reverse()
                            longDescription = ancestors.concat([m]).map((m) => m.description).join(" --> ")
                            console.log("\n********** Failed Unit **********")
                            console.log("Test: #{longDescription}")
                            console.log("Unit: #{n.description}")
                            console.log("Index: #{index}")
                        )
                    )
                    console.log("\n" + (
                        if exceptionTests.length == 0 and failureCount == 0
                            "Completed. All tests are OK. All units succeeded."
                        else
                            "Completed. #{exceptionTests.length} exceptional tests. " +
                                    "#{failureCount} failed units."
                    ) + "\n")
                    process.exit() if process?
            timer = setInterval(timerJob, 1000)
            setTimeout(timerJob, 0)
        @
    end: (result) ->
        @result = result ? {type: true}
        @
    unit: (body, description = "") ->
        parsed = null
        do =>
            quote = null
            parenthesis = 0
            bracket = 0
            brace = 0
            for i in [0...body.length]
                if body[i] == "\"" and quote == null
                    quote = "double"
                else if body[i] == "'" and quote == null
                    quote = "single"
                else if (body[i] == "\"" and quote == "double") or (body[i] == "'" and quote == "single")
                    quote = null
                else if body[i] == "("
                    parenthesis++
                else if body[i] == "["
                    bracket++
                else if body[i] == "{"
                    brace++
                else if body[i] == ")"
                    parenthesis--
                else if body[i] == "]"
                    bracket--
                else if body[i] == "}"
                    brace--
                else if quote == null and parenthesis == bracket == brace == 0
                    if body[i] == "="
                        parsed =
                            type: "equal"
                            str1: body.substr(0, i).trim()
                            str2: body.substr(i + 1).trim()
                        return
        # An `eval` string must be enclosed by parentheses, otherwise
        # an object literal (i.e. wrapped in braces) can't be evaluated.
        do =>
            if parsed.type == "equal"
                @equal(eval("(#{parsed.str1})"), eval("(#{parsed.str2})"), body)
    equal: (actual, expected, description = "") ->
        determine = (actual, expected) =>
            if Array.isArray(actual) and Array.isArray(expected)
                if expected.every((m, index) => determine(actual[index], m))
                    true
                else
                    false
            else if typeof actual == "object" and actual != null and
                    typeof expected == "object" and expected != null
                if Object.keys(expected).every((m) => determine(actual[m], expected[m]))
                    true
                else
                    false
            else if typeof actual == "number" and typeof expected == "number"
                # +0 and -0 things. +0 and -0 should be treated as NOT equal.
                if actual == 0 and expected == 0 and 1 / actual != 1 / expected
                    false
                else
                    actual == expected
            else
                actual == expected
        @unitResults.push(
            type: determine(actual, expected)
            description: description
        )
        @
