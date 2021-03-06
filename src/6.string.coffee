# TODO: This code is from my website in 2011. Needs arrangement.
# 这个函数是模拟C#中的String.Format，但我不用静态方法的风格，而是用更简洁的字符串对象的方法的风格。
# 这个函数和C#有一点不同，就是如果碰到类似"abc{def}gh"之类的字符串时，并不会出错。C#里面是只能写成
# "abc{{def}}gh"，而我这个函数两者都可以，在大括号内没有数字时，大括号不会被转义。当然，这种情况下
# 最好还是写两个大括号。
# 原先我用正则表达式实现，但发觉有一个bug，就是当两个{n}很接近时会部分转义失败，这是因为javascript
# 正则表达式的断言功能不完整导致没法使一个块不被放进结果集，从而无法使该块被再次利用。我想了半天，
# 无法在正则表达式体系中解决这个问题，就改用了循环。
# 目前这个函数只支持最多10个自定义转义符。
String::format = ->
    s = @valueOf()
    m = []
    i = 0
    while i < s.length
        cur = s[i]
        next = s[i + 1]
        if cur == "{" and next == "{"
            m.push("{", "")
            i++
        else if cur == "}" and next == "}"
            m.push("}", "")
            i++
        else if cur == "{" and next >= "0" and next <= "9" and s[i + 2] == "}"
            m.push(arguments[parseInt(next, 10)].toString(), "", "")
            i += 2
        else
            m.push(cur)
        i++
    m.join("")

String::insert = (index, value) ->
    s = @valueOf()
    s.substr(0, index) + value + s.substr(index)

String::remove = (start, length = 1) ->
    s = @valueOf()
    s.substr(0, start) + s.substr(start + length)

# Better than the built-in regular expression method when global mode
# and submatches are both required.
# It always uses global mode and returns an array of arrays if any matches are found.
# If not, it returns an empty array.
String::matches = (regex) ->
    adjustedRegex = new RegExp(regex.source, "g")
    result = []
    loop
        match = adjustedRegex.exec(@valueOf())
        if match?
            result.push(match)
        else
            break
    result

String::capitalize = ->
    # Use `charAt[0]` instead of `[0]` because `[0]` will return undefined if string is empty.
    @charAt(0).toUpperCase() + @substr(1)

String::deepSplit = (args...) ->
    arr = @split(args[0])
    if args.length == 2 and typeof args[1] == "number"
        if args[1] == 0
            [arr.join(args[0])]
        else if args[1] <= arr.length - 2
            arr[..args[1] - 1].concat([arr[args[1]..].join(args[0])])
        else
            arr
    else if args.length <= 1
        arr
    else
        arr.map((s) => s.deepSplit(args[1..]...))

String::stripTrailingNewline = ->
    if @[@length - 2] == "\r" and @[@length - 1] == "\n"
        @substr(0, @length - 2)
    else if @[@length - 1] == "\n"
        @substr(0, @length - 1)
    else
        @valueOf()
String::ensureTrailingNewline = ->
    if @[@length - 1] != "\n"
        @valueOf() + "\n"
    else
        @valueOf()
