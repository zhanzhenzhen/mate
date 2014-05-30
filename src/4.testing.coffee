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
                    allTests.forEach((m) => m.unitResults.forEach((n) =>
                        if n.type == false
                            failureCount++
                            ancestors = m.getAncestors()
                            ancestors.reverse()
                            longDescription = ancestors.concat([m]).map((m) => m.description).join(" --> ")
                            console.log("\n********** Failed Unit **********")
                            console.log("    Test: #{longDescription}")
                            console.log("    Unit: #{n.description}")
                            console.log("Expected: #{n.expected}")
                            console.log("  Actual: #{n.actual}")
                    ))
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
    equal: (actual, ruler, description = "") ->
        objects = [] # This variable is to avoid circular object/array.
        determine = (actual, ruler) =>
            if Array.isArray(actual) and Array.isArray(ruler)
                if ruler.every((m, index) =>
                    if m in objects
                        $mate.testing.objectIs(actual[index], m)
                    else
                        objects.push(m) if typeof m == "object" and m != null
                        determine(actual[index], m)
                )
                    true
                else
                    false
            else if typeof actual == "object" and actual != null and
                    typeof ruler == "object" and ruler != null
                if Object.keys(ruler).every((m) =>
                    if ruler[m] in objects
                        $mate.testing.objectIs(actual[m], ruler[m])
                    else
                        objects.push(ruler[m]) if typeof ruler[m] == "object" and ruler[m] != null
                        determine(actual[m], ruler[m])
                )
                    true
                else
                    false
            else
                $mate.testing.objectIs(actual, ruler)
        newResult =
            type: determine(actual, ruler)
            description: description
        if newResult.type == false
            newResult.actual = $mate.testing.valueToMessage(actual)
            newResult.expected = "= " + $mate.testing.valueToMessage(ruler)
        @unitResults.push(newResult)
        @
    notEqual: (actual, ruler, description = "") ->
        objects = [] # This variable is to avoid circular object/array.
        determine = (actual, ruler) =>
            if Array.isArray(actual) and Array.isArray(ruler)
                if ruler.some((m, index) =>
                    if m in objects
                        not $mate.testing.objectIs(actual[index], m)
                    else
                        objects.push(m) if typeof m == "object" and m != null
                        determine(actual[index], m)
                )
                    true
                else
                    false
            else if typeof actual == "object" and actual != null and
                    typeof ruler == "object" and ruler != null
                if Object.keys(ruler).some((m) =>
                    if ruler[m] in objects
                        not $mate.testing.objectIs(actual[m], ruler[m])
                    else
                        objects.push(ruler[m]) if typeof ruler[m] == "object" and ruler[m] != null
                        determine(actual[m], ruler[m])
                )
                    true
                else
                    false
            else
                not $mate.testing.objectIs(actual, ruler)
        newResult =
            type: determine(actual, ruler)
            description: description
        if newResult.type == false
            newResult.actual = $mate.testing.valueToMessage(actual)
            newResult.expected = "≠ " + $mate.testing.valueToMessage(ruler)
        @unitResults.push(newResult)
        @
    is: (actual, ruler, description = "") ->
        newResult =
            type: $mate.testing.objectIs(actual, ruler)
            description: description
        if newResult.type == false
            newResult.actual = $mate.testing.valueToMessage(actual)
            newResult.expected = "is " + $mate.testing.valueToMessage(ruler)
        @unitResults.push(newResult)
        @
    isnt: (actual, ruler, description = "") ->
        newResult =
            type: not $mate.testing.objectIs(actual, ruler)
            description: description
        if newResult.type == false
            newResult.actual = $mate.testing.valueToMessage(actual)
            newResult.expected = "isn't " + $mate.testing.valueToMessage(ruler)
        @unitResults.push(newResult)
        @
    throws: (fun, ruler, description = "") ->
        passed = false
        resultType =
            try
                fun()
                passed = true
                false
            catch error
                if not ruler?
                    true
                else if ruler instanceof RegExp
                    if ruler.test(error.message)
                        true
                    else
                        false
                else
                    if error instanceof ruler
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
$mate.testing.objectIs = (a, b) ->
    if typeof a == "number" and typeof b == "number"
        if a == 0 and b == 0
            1 / a == 1 / b
        else if isNaN(a) and isNaN(b)
            true
        else
            a == b
    else
        a == b
$mate.testing.valueToMessage = (value) ->
    internal = (value, maxLevel) ->
        if value == undefined
            "undefined"
        else if value == null
            "null"
        else if Array.isArray(value)
            if maxLevel > 0
                "[" + value.map((m) -> internal(value[m], maxLevel - 1)).join(",") + "]"
            else
                "[Array]"
        else if typeof value == "function"
            "[Function]"
        else if typeof value == "object"
            if maxLevel > 0
                "{" + Object.keys(value).map((m) -> "#{m}:" + internal(value[m], maxLevel - 1))
                        .join(",") + "}"
            else
                "[Object]"
        else if typeof value == "string"
            JSON.stringify(value.toString())
        else
            value.toString()
    r = internal(value, 3)
    r = internal(value, 2) if r.length > 1000
    r = internal(value, 1) if r.length > 1000
    r
featureLoaders.push(->
    global.Test = $mate.testing.Test
)
