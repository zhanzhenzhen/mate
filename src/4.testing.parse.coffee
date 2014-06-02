# `slashQuoteReady` indicates whether a slash is related to regex, or math division.
# `dotAffected` is to do with things like `abc  .   def`.

# I used to use regex for this parser, but nearly all JS engine cannot execute it well.
# Some report errors. Node even hangs up with CPU usage 100%. Very weird.
# Maybe it's because this regex is very complicated, and nested. So I gave it up.
npmMate.testing.parseFunction = (funStr, envNames) ->
    keywords = envNames ? ["finish", "unit"]
    if keywords.length == 0 then return []
    regex = new RegExp("^(" + keywords.join("|") + ")[^a-zA-Z0-9_$]", "g")
    positions = []
    quote = null
    slashQuoteReady = true
    wordStarted = false
    dotAffected = false
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
            s = funStr.substr(i, 31) # limit to 31 chars for better performance (max keyword length is 30)
            if s.search(regex) != -1
                positions.push(i)
            i++
        else
            i++
    positions
# `unitStr` must be an already-trimmed string
npmMate.testing.parseUnitString = (unitStr) ->
    parsed = null
    quote = null
    parenthesis = 0
    bracket = 0
    brace = 0
    slashQuoteReady = true
    dotAffected = false
    i = 0
    while i < unitStr.length
        c = unitStr[i]
        oldSlashQuoteReady = slashQuoteReady
        if quote == null
            if "a" <= c <= "z" or "A" <= c <= "Z" or "0" <= c <= "9" or
                    c == "_" or c == "$" or c == ")" or c == "]"
                slashQuoteReady = false
            else if c == " " or c == "\t" or c == "\n" or c == "\r"
            else
                slashQuoteReady = true
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
        else if c == "("
            parenthesis++
            i++
        else if c == "["
            bracket++
            i++
        else if c == "{"
            brace++
            i++
        else if c == ")"
            parenthesis--
            i++
        else if c == "]"
            bracket--
            i++
        else if c == "}"
            brace--
            i++
        else if quote == null and not oldDotAffected and parenthesis == bracket == brace == 0
            s = unitStr.substr(i)
            if (match = s.match(/// ^ = ([^]+) $ ///))?
                parsed =
                    type: "equal"
                    components: [
                        unitStr.substr(0, i)
                        match[1]
                    ]
                break
            else if (match = s.match(/// ^ <> ([^]+) $ ///))?
                parsed =
                    type: "notEqual"
                    components: [
                        unitStr.substr(0, i)
                        match[1]
                    ]
                break
            else if (match = s.match(/// ^ \s is \s ([^]+) $ ///))?
                parsed =
                    type: "is"
                    components: [
                        unitStr.substr(0, i)
                        match[1]
                    ]
                break
            else if (match = s.match(/// ^ \s isnt \s ([^]+) $ ///))?
                parsed =
                    type: "isnt"
                    components: [
                        unitStr.substr(0, i)
                        match[1]
                    ]
                break
            else if (match = s.match(///^ \s throws (?: \s ([^]+))? $ ///))?
                parsed =
                    type: "throws"
                    components: [
                        unitStr.substr(0, i)
                        if match[1]? then match[1] else "undefined"
                    ]
                break
            i++
        else
            i++
    parsed ?=
        type: "doesNotThrow"
        components: [
            unitStr
        ]
    parsed.components = parsed.components.map((m) -> m.trim())
    parsed
