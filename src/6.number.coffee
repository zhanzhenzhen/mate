Number.isFraction = (x) -> typeof x == "number" and isFinite(x) and Math.floor(x) != x
Number.parseFloatExt = (s) -> parseFloat(s) * (if s.endsWith("%") then 0.01 else 1)
Number::approxEquals = (x) -> Math.approxEquals(@valueOf(), x)
Number::approxGreaterThan = (x) -> Math.approxGreaterThan(@valueOf(), x)
Number::approxLessThan = (x) -> Math.approxLessThan(@valueOf(), x)
Number::pad = (integerSize, fractionalSize) ->
    @valueOf().format(
        integerSize: integerSize
        fractionalSize: fractionalSize
    )
Number::format = (options) ->
    integerSize = options?.integerSize ? 1
    fractionalSize = options?.fractionalSize ? 0
    forcesSign = options?.forcesSign ? false
    radix = options?.radix ? 10
    integerGroupEnabled = options?.integerGroupEnabled ? false
    integerGroupSeparator = options?.integerGroupSeparator ? ","
    integerGroupSize = options?.integerGroupSize ? 3
    fractionalGroupEnabled = options?.fractionalGroupEnabled ? false
    fractionalGroupSeparator = options?.fractionalGroupSeparator ? " "
    fractionalGroupSize = options?.fractionalGroupSize ? 3
    x = @valueOf()
    s = x.toString(radix)
    do ->
        pos = s.indexOf(".")
        rawIntegerSize = if pos == -1 then s.length else pos
        integerMissing = Math.max(integerSize - rawIntegerSize, 0)
        rawFractionalSize = if pos == -1 then 0 else s.length - 1 - pos
        fractionalMissing = fractionalSize - rawFractionalSize
        # For truncating. If `fractionalMissing` is negative then truncate, otherwise it
        # will remain unchanged. ==========[
        s = s.substr(0, s.length + fractionalMissing)
        if s[s.length - 1] == "." then s = s.substr(0, s.length - 1)
        # ]====================
        if pos == -1 and fractionalSize > 0 then s += "."
        s = "0".repeat(integerMissing) + s + "0".repeat(Math.max(fractionalMissing, 0))
        if forcesSign and s[0] != "-" then s = "+" + s
    if integerGroupEnabled or fractionalGroupEnabled then do ->
        pos = s.indexOf(".")
        if fractionalGroupEnabled
            fractionalStart = (if pos == -1 then s.length else pos) + 1 + fractionalGroupSize
            s = s.insert(
                for i in [fractionalStart..s.length - 1] by fractionalGroupSize
                    {index: i, value: fractionalGroupSeparator}
            )
        if integerGroupEnabled
            integerStart = (if pos == -1 then s.length else pos) - integerGroupSize
            integerEnd = if s[0] == "+" or s[0] == "-" then 2 else 1
            s = s.insert(
                (
                    for i in [integerStart..integerEnd] by -integerGroupSize
                        {index: i, value: integerGroupSeparator}
                ).funReverse()
            )
    s
