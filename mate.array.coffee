class ArrayLazyWrapper
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
    # simulate `Array`'s methods ---
    map: -> @_pushChain(Array::map, arguments)
    filter: -> @_pushChain(Array::filter, arguments)
    concat: -> @_pushChain(Array::concat, arguments)
    portion: -> @_pushChain(Array::portion, arguments)
    funSort: -> @_pushChain(Array::funSort, arguments)
    funSortDescending: -> @_pushChain(Array::funSortDescending, arguments)
    funReverse: -> @_pushChain(Array::funReverse, arguments)
    random: -> @_pushChain(Array::random, arguments)
    some: -> @_unwrapAndDo(Array::some, arguments)
    every: -> @_unwrapAndDo(Array::every, arguments)
    isEmpty: -> @_unwrapAndDo(Array::isEmpty, arguments)
    at: -> @_unwrapAndDo(Array::at, arguments)
    contains: -> @_unwrapAndDo(Array::contains, arguments)
    first: -> @_unwrapAndDo(Array::first, arguments)
    last: -> @_unwrapAndDo(Array::last, arguments)
    single: -> @_unwrapAndDo(Array::single, arguments)
    withMax: -> @_unwrapAndDo(Array::withMax, arguments)
    withMin: -> @_unwrapAndDo(Array::withMin, arguments)
    max: -> @_unwrapAndDo(Array::max, arguments)
    min: -> @_unwrapAndDo(Array::min, arguments)
    sum: -> @_unwrapAndDo(Array::sum, arguments)
    average: -> @_unwrapAndDo(Array::average, arguments)
    randomOne: -> @_unwrapAndDo(Array::randomOne, arguments)
    # ---
    _pushChain: (fun, args) ->
        # Must create a new wrapper to avoid side effects
        new ArrayLazyWrapper(@_value, @_chain, {fun: fun, args: args})
    _unwrapAndDo: (fun, args) -> fun.apply(@force(), args)
# If the element is a number or string, it will be more convenient
# to use the element itself without a selector.
Array._elementOrUseSelector = (element, selector) -> if selector? then selector(element) else element
Array::_numberToIndex = (pos) -> if 0 < pos < 1 then pos = Math.round(pos * (@length - 1)) else pos
Array::_numberToLength = (pos) -> if 0 < pos < 1 then pos = Math.round(pos * @length) else pos
# We name it "copy" instead of "clone" because "clone" is more related to object
# and its properties/methods. This method does not copy array methods or negative index values
# so it's just "copy".
Array::copy = -> @[..]
Array::isEmpty = -> @length == 0
Array::lazy = -> new ArrayLazyWrapper(@)
Array::portion = (startIndex, length, endIndex) ->
    startIndex = @_numberToIndex(startIndex)
    length = @_numberToLength(length)
    endIndex = @_numberToIndex(endIndex)
    @slice(startIndex, if length? then startIndex + length else endIndex)
Array::at = (index) ->
    index = @_numberToIndex(index)
    assert(0 <= index < @length)
    @[index]
Array::contains = (value) -> value in @
# TODO: performance
Array::first = (predicate) ->
    queryResult = if predicate? then @filter(predicate) else @
    queryResult.at(0)
# TODO: performance
Array::last = (predicate) ->
    queryResult = if predicate? then @filter(predicate) else @
    queryResult.at(queryResult.length - 1)
Array::single = (predicate) ->
    queryResult = if predicate? then @filter(predicate) else @
    assert(queryResult.length == 1)
    queryResult.at(0)
Array::withMax = (selector) -> @reduce((a, b, index) =>
    if Array._elementOrUseSelector(a, selector) > Array._elementOrUseSelector(b, selector) then a else b
)
Array::withMin = (selector) -> @reduce((a, b, index) =>
    if Array._elementOrUseSelector(a, selector) < Array._elementOrUseSelector(b, selector) then a else b
)
Array::max = (selector) -> Array._elementOrUseSelector(@withMax(selector), selector)
Array::min = (selector) -> Array._elementOrUseSelector(@withMin(selector), selector)
Array::sum = (selector) -> @reduce((a, b, index) =>
    (if index == 1 then Array._elementOrUseSelector(a, selector) else a) +
    Array._elementOrUseSelector(b, selector)
)
Array::average = (selector) -> @sum(selector) / @length
Array::_sort = (keySelector, isDescending) ->
    @copy().sort((a, b) =>
        a1 = Array._elementOrUseSelector(a, keySelector)
        b1 = Array._elementOrUseSelector(b, keySelector)
        if a1 < b1 then (if isDescending then 1 else -1)
        else if a1 > b1 then (if isDescending then -1 else 1)
        else 0
    )
Array::funSort = (keySelector) -> @_sort(keySelector, false)
Array::funSortDescending = (keySelector) -> @_sort(keySelector, true)
Array::funReverse = -> @copy().reverse()
Array::randomOne = -> @[Math.randomInt(@length)]
Array::random = (count) -> @copy().takeRandom(count)
Array::takeRandomOne = ->
    index = Math.randomInt(@length)
    r = @[index]
    @splice(index, 1)
    r
Array::takeRandom = (count) ->
    count ?= @length
    count = @_numberToLength(count)
    repeat(count, => @takeRandomOne())
