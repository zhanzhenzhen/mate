###

This is to test the "test". The output should look something like that:

2014-05-21T09:48:13.003Z OK: 7, Exception: 0, Pending: 1
2014-05-21T09:48:14.001Z OK: 7, Exception: 0, Pending: 1
2014-05-21T09:48:15.002Z OK: 7, Exception: 0, Pending: 1
2014-05-21T09:48:16.002Z OK: 8, Exception: 0, Pending: 0

********** Failed Unit **********
    Test: root --> 
    Unit: 1+2+3=7
Expected: 7
  Actual: 6

********** Failed Unit **********
    Test: root --> 
    Unit:   (obj.unit>1)=true
Expected: true
  Actual: false

********** Failed Unit **********
    Test: root --> nested test --> test 2 in nested test
    Unit: simple boolean test
Expected: true
  Actual: false

********** Failed Unit **********
    Test: root --> 
    Unit: ("1"===2)=true
Expected: true
  Actual: false

Completed. 0 exceptional tests. 4 failed units.

###

if exports? and module?.exports?
    Test = require("../mate").testing.Test
    global.unitsomething = -> true
else
    Test = $mate.testing.Test
    window.unitsomething = -> true
new Test("root"
).add("String.prototype test", ->
    str = "hello world"
    unit(' str.substr(4,1)="o" ')
    unit(' str.split(" ")=["hello","world"] ')
    unit(' str.split(" ")=["hello","world"] ')
    unitsomething()
).add(->
    unit('Math.round(5.3)=5')
).add(->
    unit('1+2+3=7')
).add(->
    obj = {}
    obj.unit = ->
        Math.random()
    obj.unit()
    unit('  (obj.unit>1)=true')
).add(
    new Test("nested test"
    ).add("test 1 in nested test", ->
        unit('false=false')
    ).add("test 2 in nested test", ->
        unit("false=true", "simple boolean test")
    )
).add("simple test 2", ->
    setTimeout(->
        unit("true=true", "truthy unit")
        finish()
    , 2500)
).add(->
    unit("(\"1\"===2)=true")
).add(->
    unit("{} is {}")
    unit("    [] is []             ")
    unit("NaN is NaN")
    unit("NaN = NaN")
    unit("NaN= 3")
    unit("'' =NaN")
    unit("0=0")
    unit("0=-0")
    unit("0 is -0")
    unit("-0 is 0")
    class CustomError extends Error
        constructor: (msg) -> super(msg)
    a = ->
        throw new Error()
    b = ->
    c = ->
        throw new CustomError()
    unit('a throws')
    unit('b throws')
    unit('a throws /kkk/')
    unit('a throws /^$/')
    unit('a throws Error')
    unit('a throws CustomError')
    unit('c throws Error')
    unit('c throws CustomError')
    unit('b')
    unit('a')
).run()
