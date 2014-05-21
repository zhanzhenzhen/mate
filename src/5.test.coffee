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
            do =>
                # not global, only replace first "(...)"
                funStr = funStr.replace(/\([^\)]*\)/, "(#{testArgName})")
            # Recover dot notation.
            # I used to use regex for this parser, but nearly all JS engine cannot execute it well.
            # Some report errors. Node even hangs up with CPU usage 100%. Very weird.
            # Maybe it's because this regex is very complicated, and nested. So I gave it up.
            do =>
                positions = []
                quote = null
                slashQuoteReady = true # indicates whether a slash is related to regex, or math division
                wordStarted = false
                dotAffected = false # this is to do with things like `abc  .   def`
                i = 0
                while i < funStr.length
                    c = funStr[i]
                    oldSlashQuoteReady = slashQuoteReady
                    if quote == null
                        if "a" <= c <= "z" or "A" <= c <= "Z" or "0" <= c <= "9" or
                                c == "_" or c == "$" or c == ")" or c == "]"
                            slashQuoteReady = false
                        else if c == " " or c == "\t" or c == "\n" or c == "\r"
                        else
                            slashQuoteReady = true
                    oldWordStarted = wordStarted
                    if quote == null
                        if "a" <= c <= "z" or "A" <= c <= "Z" or "0" <= c <= "9" or
                                c == "_" or c == "$" or c == "."
                            wordStarted = true
                        else
                            wordStarted = false
                    oldDotAffected = dotAffected
                    if quote == null
                        if c == "."
                            dotAffected = true
                        else if c == " " or c == "\t" or c == "\n" or c == "\r"
                        else
                            dotAffected = false
                    if c == "\"" and quote == null
                        quote = "double"
                        i++
                    else if c == "'" and quote == null
                        quote = "single"
                        i++
                    else if c == "/" and quote == null and oldSlashQuoteReady
                        quote = "slash"
                        i++
                    else if (c == "\"" and quote == "double") or
                            (c == "'" and quote == "single") or
                            (c == "/" and quote == "slash")
                        quote = null
                        i++
                    else if c == "\\" and quote != null
                        i += 2
                    else if quote == null and not oldWordStarted and not oldDotAffected and "a" <= c <= "z"
                        s = funStr.substr(i, 10) # limit to 10 chars for better performance
                        if s.indexOf("finish") == 0 or s.indexOf("equal") == 0 or s.indexOf("unit") == 0
                            positions.push(i)
                        i++
                    else
                        i++
                positions.forEach((m, index) =>
                    pos = m + (testArgName.length + 1) * index
                    funStr = funStr.substr(0, pos) + testArgName + "." + funStr.substr(pos)
                )
            # Recover the actual methods from the symbolic `unit` method.
            do =>
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
                    unitStr = eval(p1) # If use `JSON.parse` instead, single quotes string cannot be parsed.
                    parsed = null
                    newStr = null
                    do =>
                        quote = null
                        parenthesis = 0
                        bracket = 0
                        brace = 0
                        for i in [0...unitStr.length]
                            c = unitStr[i]
                            if c == "\"" and quote == null
                                quote = "double"
                            else if c == "'" and quote == null
                                quote = "single"
                            else if (c == "\"" and quote == "double") or
                                    (c == "'" and quote == "single")
                                quote = null
                            else if c == "("
                                parenthesis++
                            else if c == "["
                                bracket++
                            else if c == "{"
                                brace++
                            else if c == ")"
                                parenthesis--
                            else if c == "]"
                                bracket--
                            else if c == "}"
                                brace--
                            else if quote == null and parenthesis == bracket == brace == 0
                                if c == "="
                                    parsed =
                                        type: "equal"
                                        str1: unitStr.substr(0, i).trim()
                                        str2: unitStr.substr(i + 1).trim()
                                    return
                    do =>
                        if parsed.type == "equal"
                            newStr = "#{testArgName}.equal(#{parsed.str1}, #{parsed.str2}, #{p2 ? p1})"
                    newStr
                )
            funStr_834942610148628375 = funStr
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
            else if typeof actual == "number" and typeof expected == "number"
                # +0 and -0 things. +0 and -0 should be treated as NOT equal.
                if actual == 0 and expected == 0 and 1 / actual != 1 / expected
                    false
                else
                    actual == expected
            else
                actual == expected
        newResult =
            type: determine(actual, expected)
            description: description
        if newResult.type == false
            newResult.actual = JSON.stringify(actual)
            newResult.expected = JSON.stringify(expected)
        @unitResults.push(newResult)
        @
