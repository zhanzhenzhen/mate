# This file must NOT depend on any other parts of the project except "prelude.coffee"
# and "testing.**.coffee". Because this file will be used to test other parts.
# Otherwise the test result may be incorrect.

class $mate.testing.Test
    constructor: (@description = "") ->
        @_children = []
        @_fun = null
        @_interpretedFunction = null
        @async = false
        @parent = null
        @unitResults = []
        @result = null
    set: (fun) ->
        @_fun = fun
        funStr_834942610148628375 = null
        # Why wrap all these things into a `do`? Because we want to avoid disclosing variables
        # to `eval`. The only variable disclosed is `funStr_834942610148628375`, which user
        # is unlikely to use.
        do =>
            funStr = fun.toString()
            # This is only to ensure the argument name will be not used by user.
            # We must interprete the "pretty" function to an "ugly" function as an intermediate
            # layer using this mechanism. The missing argument representing the test object
            # in the "pretty" function will be added, as well as the missing dot notation in
            # unit declarations.
            # The key point is that the "pretty" function is legal. It fully complies with
            # JavaScript (or CoffeeScript) grammars.
            testArgName = "testArg_834942610148628375"
            # Recover argument.
            # not global, only replace first "(...)"
            funStr = funStr.replace(/\([^\)]*\)/, "(#{testArgName})")
            # Recover dot notation.
            $mate.testing.parseFunction(funStr).forEach((m, index) =>
                pos = m + (testArgName.length + 1) * index
                funStr = funStr.substr(0, pos) + testArgName + "." + funStr.substr(pos)
            )
            # Recover the actual methods from the symbolic `unit` method.
            # Important: The `unit` method must be symbolic. If it has a real `unit` method,
            # there is no way to evaluate the variables that is contained in a unit string
            # inside this method.
            # Actually, while `set` method begins, `unit` is a symbolic function. As of this position
            # it's a symbolic method.
            funStr = funStr.replace(///
                #{testArgName}\.unit \s* \( \s*
                (
                    " (?: [^"\\] | \\. )* " |
                    ' (?: [^'\\] | \\. )* '
                )
                (?:
                    \s* , \s*
                    (
                        " (?: [^"\\] | \\. )* " |
                        ' (?: [^'\\] | \\. )* '
                    )
                )? \s* \)
            ///g, (match, p1, p2) =>
                # In Firefox if there's no p2 then p2 is "". This may be a bug of Firefox.
                # This statement is only a workaround for Firefox.
                if p2 == "" then p2 = undefined
                # Why use `eval` to strip p1? Because if we use string methods to strip it,
                # then escaped characters can't be processed.
                # If use `JSON.parse` instead, then single quotes string cannot be parsed.
                unitStr = eval(p1).trim()
                description = p2 ? JSON.stringify(unitStr)
                parsed = $mate.testing.parseUnitString(unitStr)
                args = parsed.components
                args.push(description)
                "#{testArgName}.#{parsed.type}(#{args.join(', ')})"
            )
            funStr_834942610148628375 = funStr
            # TODO: Maybe a regex is needed? If we later implement another method
            # named as `finishSomething`, then it won't work correctly. But most likely we
            # will never implement such methods.
            @async = funStr.indexOf("#{testArgName}.finish") != -1
        # `eval` here exactly meets our requirement. It also works in ES5 "strict mode",
        # because it does not introduce new variables into the surrounding scope.
        # If an `eval` string has leading or trailing braces, then it must be enclosed
        # by parentheses, otherwise it can't be parsed or evaluated.
        @_interpretedFunction = eval("(#{funStr_834942610148628375})")
        @
    get: ->
        @_fun
    add: (description, fun) ->
        if typeof description == "object"
            newChild = description
        else
            if typeof description != "string"
                fun = description
                description = ""
            newChild = new $mate.testing.Test(description).set(fun)
        newChild.parent = @
        @_children.push(newChild)
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
                    @_interpretedFunction(@)
                    if not @async then @finish(type: true)
                if exports? and module?.exports?
                    domain = require("domain").create()
                    domain.on("error", (error) =>
                        @finish(
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
                        @finish(type: false)
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
                        m.unitResults.filter((m) => m.type == false).forEach((n) =>
                            failureCount++
                            ancestors = m.getAncestors()
                            ancestors.reverse()
                            longDescription = ancestors.concat([m]).map((m) => m.description).join(" --> ")
                            console.log("\n********** Failed Unit **********")
                            console.log("    Test: #{longDescription}")
                            console.log("    Unit: #{n.description}")
                            console.log("Expected: #{n.expected}")
                            console.log("  Actual: #{n.actual}")
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
    finish: (result) ->
        @result = result ? {type: true}
        @
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
            else
                objectIs(actual, expected)
        newResult =
            type: determine(actual, expected)
            description: description
        if newResult.type == false
            newResult.actual = testResultValueToMessage(actual)
            newResult.expected = "= " + testResultValueToMessage(expected)
        @unitResults.push(newResult)
        @
    is: (actual, expected, description = "") ->
        newResult =
            type: objectIs(actual, expected)
            description: description
        if newResult.type == false
            newResult.actual = testResultValueToMessage(actual)
            newResult.expected = "is " + testResultValueToMessage(expected)
        @unitResults.push(newResult)
        @
    throws: (fun, expected, description = "") ->
        passed = false
        resultType =
            try
                fun()
                passed = true
                false
            catch error
                if not expected?
                    true
                else if expected instanceof RegExp
                    if expected.test(error.message)
                        true
                    else
                        false
                else
                    if error instanceof expected
                        true
                    else
                        false
        newResult =
            type: resultType
            description: description
        if newResult.type == false
            newResult.actual = if passed then "no exception" else "another exception"
            newResult.expected = if passed then "exception" else "an exception"
        @unitResults.push(newResult)
        @
    doesNotThrow: (fun, description = "") ->
        resultType =
            try
                fun()
                true
            catch
                false
        newResult =
            type: resultType
            description: description
        if newResult.type == false
            newResult.actual = "exception"
            newResult.expected = "no exception"
        @unitResults.push(newResult)
        @
# This function is equivalent to ECMAScript 6th's `Object.is`.
objectIs = (a, b) ->
    if typeof a == "number" and typeof b == "number"
        if a == 0 and b == 0
            1 / a == 1 / b
        else if isNaN(a) and isNaN(b)
            true
        else
            a == b
    else
        a == b
testResultValueToMessage = (value) ->
    # Using "_834942610148628375" is to avoid ambiguous values. For example, if we
    # use only "NaN" then if a string value happens to be "NaN" then it's ambiguous.
    JSON.stringify(value, (key, value) ->
        if typeof value == "number"
            if value != value # Can't use `isNaN`. Weird. If use `isNaN` then always true.
                "NaN_834942610148628375"
            else if value == Infinity
                "Infinity_834942610148628375"
            else if value == -Infinity
                "-Infinity_834942610148628375"
            else if objectIs(value, -0)
                "-0_834942610148628375"
            else
                value
        else if typeof value == "function"
            "[Function]_834942610148628375"
        else
            value
    ).replace(/"((?:[^"\\]|\\.)+)_834942610148628375"/g, "$1")
featureLoaders.push(->
    global.Test = $mate.testing.Test
)
