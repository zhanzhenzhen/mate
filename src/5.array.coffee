# In some `Array` methods, I enable the fraction format index and length for convenience.
# Except that, all `Array` methods arguments are very "strict" without any multi-use purpose.

class Array._ArrayLazyWrapper
    constructor: (value, chainToCopy, itemToPush) ->
        @_value = value
        @_chain = (chainToCopy ? [])[..]
        @_chain.push(itemToPush) if itemToPush?
        Object.getter(@, "length", => @force().length) # simulate `Array`'s `length`
    force: ->
        n = @_value
        for m in @_chain
            n = m.fun.apply(n, m.args)
        n
    # simulate `Array`'s methods [
    map: -> @_pushChain(Array::map, arguments)
    filter: -> @_pushChain(Array::filter, arguments)
    concat: -> @_pushChain(Array::concat, arguments)
    portion: -> @_pushChain(Array::portion, arguments)
    funSort: -> @_pushChain(Array::funSort, arguments)
    funSortDescending: -> @_pushChain(Array::funSortDescending, arguments)
    funReverse: -> @_pushChain(Array::funReverse, arguments)
    except: -> @_pushChain(Array::except, arguments)
    group: -> @_pushChain(Array::group, arguments)
    flatten: -> @_pushChain(Array::flatten, arguments)
    random: -> @_pushChain(Array::random, arguments)
    some: -> @_unwrapAndDo(Array::some, arguments)
    every: -> @_unwrapAndDo(Array::every, arguments)
    isEmpty: -> @_unwrapAndDo(Array::isEmpty, arguments)
    at: -> @_unwrapAndDo(Array::at, arguments)
    atOrNull: -> @_unwrapAndDo(Array::atOrNull, arguments)
    contains: -> @_unwrapAndDo(Array::contains, arguments)
    first: -> @_unwrapAndDo(Array::first, arguments)
    firstOrNull: -> @_unwrapAndDo(Array::firstOrNull, arguments)
    last: -> @_unwrapAndDo(Array::last, arguments)
    lastOrNull: -> @_unwrapAndDo(Array::lastOrNull, arguments)
    single: -> @_unwrapAndDo(Array::single, arguments)
    singleOrNull: -> @_unwrapAndDo(Array::singleOrNull, arguments)
    withMax: -> @_unwrapAndDo(Array::withMax, arguments)
    withMin: -> @_unwrapAndDo(Array::withMin, arguments)
    max: -> @_unwrapAndDo(Array::max, arguments)
    min: -> @_unwrapAndDo(Array::min, arguments)
    sum: -> @_unwrapAndDo(Array::sum, arguments)
    average: -> @_unwrapAndDo(Array::average, arguments)
    median: -> @_unwrapAndDo(Array::median, arguments)
    product: -> @_unwrapAndDo(Array::product, arguments)
    randomOne: -> @_unwrapAndDo(Array::randomOne, arguments)
    # ]
    _pushChain: (fun, args) ->
        # Must create a new wrapper to avoid side effects
        new Array._ArrayLazyWrapper(@_value, @_chain, {fun: fun, args: args})
    _unwrapAndDo: (fun, args) -> fun.apply(@force(), args)
# If the element is a number or string, it will be more convenient
# to use the element itself without a selector.
Array._elementOrUseSelector = (element, selector) -> if selector? then selector(element) else element
Array::_numberToIndex = (pos) -> if 0 < pos < 1 then pos = Math.round(pos * (@length - 1)) else pos
Array::_numberToLength = (pos) -> if 0 < pos < 1 then pos = Math.round(pos * @length) else pos
Array::clone = -> @[..]
Array::isEmpty = -> @length == 0
Array::lazy = -> new Array._ArrayLazyWrapper(@)
Array::portion = (startIndex, length, endIndex) ->
    if Number.isFraction(startIndex) or Number.isFraction(length) or Number.isFraction(endIndex)
        if startIndex == 0 then startIndex = 0 + Number.EPSILON
        if startIndex == 1 then startIndex = 1 - Number.EPSILON
        if length == 0 then length = 0 + Number.EPSILON
        if length == 1 then length = 1 - Number.EPSILON
        if endIndex == 0 then endIndex = 0 + Number.EPSILON
        if endIndex == 1 then endIndex = 1 - Number.EPSILON
    startIndex = @_numberToIndex(startIndex)
    length = @_numberToLength(length)
    endIndex = @_numberToIndex(endIndex)
    @slice(startIndex, if length? then startIndex + length else endIndex + 1)
Array::at = (index) ->
    index = @_numberToIndex(index)
    assert(0 <= index < @length)
    @[index]
Array::atOrNull = (index) -> try @at(index) catch then null
Array::contains = (value) -> value in @
# TODO: performance
Array::first = (predicate) ->
    queryResult = if predicate? then @filter(predicate) else @
    queryResult.at(0)
Array::firstOrNull = (predicate) -> try @first(predicate) catch then null
# TODO: performance
Array::last = (predicate) ->
    queryResult = if predicate? then @filter(predicate) else @
    queryResult.at(queryResult.length - 1)
Array::lastOrNull = (predicate) -> try @last(predicate) catch then null
Array::single = (predicate) ->
    queryResult = if predicate? then @filter(predicate) else @
    assert(queryResult.length == 1)
    queryResult.at(0)
Array::singleOrNull = (predicate) -> try @single(predicate) catch then null
# If array length is 1, then `reduce` will return the single element. That's exactly what
# `withMax` and `withMin` are for, so we don't need to copy what we did in `sum` method. [
Array::withMax = (selector) -> @reduce((a, b, index) =>
    if Array._elementOrUseSelector(a, selector) > Array._elementOrUseSelector(b, selector) then a else b
)
Array::withMin = (selector) -> @reduce((a, b, index) =>
    if Array._elementOrUseSelector(a, selector) < Array._elementOrUseSelector(b, selector) then a else b
)
# ]
Array::max = (selector) -> Array._elementOrUseSelector(@withMax(selector), selector)
Array::min = (selector) -> Array._elementOrUseSelector(@withMin(selector), selector)
Array::sum = (selector) ->
    if @length == 1
        Array._elementOrUseSelector(@first(), selector)
    else
        @reduce((a, b, index) =>
            (if index == 1 then Array._elementOrUseSelector(a, selector) else a) +
                    Array._elementOrUseSelector(b, selector)
        )
Array::average = (selector) -> @sum(selector) / @length
Array::median = (selector) ->
    sorted = @funSort(selector)
    a = sorted.at(0.5 - Number.EPSILON)
    b = sorted.at(0.5 + Number.EPSILON)
    m = Array._elementOrUseSelector(a, selector)
    n = Array._elementOrUseSelector(b, selector)
    (m + n) / 2
Array::product = (selector) ->
    if @length == 1
        Array._elementOrUseSelector(@first(), selector)
    else
        @reduce((a, b, index) =>
            (if index == 1 then Array._elementOrUseSelector(a, selector) else a) *
                    Array._elementOrUseSelector(b, selector)
        )
# These methods use sorting. For `keySelector`, note that the keys of all elements must be either
# all numbers, all booleans, or all strings. [
# Why don't use {key: ..., value: ...}, but a non-intuitive array for the key-value pair?
# Because ECMAScript 6th's Map constructor only accepts the array form to denote a key-value pair.
# I don't want to break the consistency.
Array::group = (keySelector, valueSelector) ->
    if @isEmpty() then return []
    sorted = @funSort(keySelector)
    results = []
    comparedKey = Array._elementOrUseSelector(sorted.first(), keySelector)
    elements = []
    for m in sorted
        key = Array._elementOrUseSelector(m, keySelector)
        if key != comparedKey
            results.push([
                comparedKey
                Array._elementOrUseSelector(elements, valueSelector)
            ])
            comparedKey = key
            elements = []
        elements.push(m)
    results.push([
        comparedKey
        Array._elementOrUseSelector(elements, valueSelector)
    ])
    results
Array::_sort = (keySelector, isDescending) ->
    @clone().sort((a, b) =>
        a1 = Array._elementOrUseSelector(a, keySelector)
        b1 = Array._elementOrUseSelector(b, keySelector)
        if a1 < b1 then (if isDescending then 1 else -1)
        else if a1 > b1 then (if isDescending then -1 else 1)
        else 0
    )
Array::funSort = (keySelector) -> @_sort(keySelector, false)
Array::funSortDescending = (keySelector) -> @_sort(keySelector, true)
# ]
Array::funReverse = -> @clone().reverse()
Array::except = (array) -> @filter((m) -> m not in array)
Array::flatten = (level) ->
    if level <= 0
        fail()
    else
        r = []
        canContinue = false
        for m in @
            if Array.isArray(m)
                canContinue = true
                r.push(n) for n in m
            else
                r.push(m)
        if canContinue
            if level?
                if level == 1
                    r
                else
                    r.flatten(level - 1)
            else
                r.flatten()
        else
            r
Array::randomOne = -> @[Math.randomInt(@length)]
Array::random = (count) -> @clone().takeRandom(count)
Array::takeRandomOne = ->
    index = Math.randomInt(@length)
    r = @[index]
    @removeAt(index)
    r
Array::takeRandom = (count) ->
    count ?= @length
    count = @_numberToLength(count)
    repeat(count, => @takeRandomOne())
Array::removeAt = (index) ->
    @splice(index, 1)
    @
# remove the first, not all
Array::remove = (element) ->
    index = @indexOf(element)
    assert(index > -1)
    @removeAt(index)
# TODO: performance
Array::removeAll = (element) ->
    loop
        index = @indexOf(element)
        if index == -1 then break
        @removeAt(index)
    @
# remove the first, not all
Array::removeMatch = (predicate) ->
    index = @findIndex(predicate)
    assert(index > -1)
    @removeAt(index)
# TODO: performance
Array::removeAllMatch = (predicate) ->
    loop
        index = @findIndex(predicate)
        if index == -1 then break
        @removeAt(index)
    @
