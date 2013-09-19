Mate is a small collection that extends CoffeeScript and JavaScript,
especially on `Array`.

    require("mate")

Array extension examples
===================================

Suppose we have a `students` array:

    students = [
        {name: "ABC", score: 80}, {name: "DEF", score: 93}, {name: "GHI", score: 72},
        {name: "AAA", score: 99}, {name: "BBB", score: 55}, {name: "CCC", score: 87},
        {name: "JKL", score: 81}, {name: "MNO", score: 79}, {name: "PQR", score: 87},
        {name: "DDD", score: 68}, {name: "EEE", score: 53}, {name: "FFF", score: 90},
        {name: "STU", score: 83}, {name: "VWX", score: 95}, {name: "YZA", score: 83},
        {name: "GGG", score: 76}
    ];

The student with the highest score (coffee|js):

    students.withMax((m) -> m.score)  |  students.withMax(function(m){return m.score;})

The first student whose score is higher than 90:

    students.first((m) -> m.score > 90)

The student with the 4th highest score:

    students.funSortDescending((m) -> m.score).at(3)

`at(n)` is similar to `[n]` but more powerful. It can be a 0 to 1 fraction, which means
the percentage. So the following returns the same as above:

    students.funSortDescending((m) -> m.score).at(0.2)

This feature exists in many methods. For example, students with ranking in score from
the first 20% to the last 20% (i.e. the middle 60%):

    students.funSortDescending((m) -> m.score).portion(0.2, 0.6)

or:

    students.funSortDescending((m) -> m.score).portion(0.2, undefined, 0.8)

Get a random sample of 5 students:

    students.random(5)

`Array` has a `lazy` method. When using `lazy`, the subsequent computations will not be
evaluated immediately, but are instead evaluated when the result is needed.

    query = students.lazy().random(5).funSort((m) -> m.score)
    a = query.force()
    b = query.force()

You will see `a` and `b` are different. After calling `force` or a method that returns
a single element, the computations will be evaluated.

(Note: It's not the same as functional languages' "lazy" concept. Also, Some
built-in methods like `sort`, `reverse` cannot be lazy because they have side-effects.
Use the functional `funSort`, `funReverse` instead. If you want to get the nth element,
either use `at(n)` or use `force()[n]`.)

Complete list:

JavaScript built-in: `map`, `filter`, `some`, `every`, `concat`

Mate: `portion`, `funSort`, `funSortDescending`, `funReverse`, `random`,
`isEmpty`, `at`, `contains`, `first`, `last`, `single`, `withMax`, `withMin`, `max`,
`min`, `sum`, `average`, `randomOne`

Function composition examples
======================================

Normal JS:

    functionD(functionC(functionB(functionA(arg))))

Mate:

    compose(functionA, functionB, functionC, functionD)(arg)

Normal JS:

    a = functionD(functionC(functionB(functionA(x))));
    b = functionD(functionC(functionB(functionA(y))));
    c = functionD(functionC(functionB(functionA(z))));

Mate:

    f = compose(functionA, functionB, functionC, functionD)
    a = f(x)
    b = f(y)
    c = f(z)

Object with events
===================================

An `ObjectWithEvents` class was introduced in Mate, so using events in an object
will be as easy as using events in DOM elements, as long as your object inherits
`ObjectWithEvents`.

Other
===========================

`fail`, `assert`, `repeat`, `Object.clone`, `JSON.clone`, `Math.randomNumber`,
`Math.randomInt`, `String::startsWith`, `String::endsWith`, `String::contains`, etc.
