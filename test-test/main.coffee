###

This is to test the "test". The output should look something like this:

2014-05-28T05:29:21.394Z OK: 8, Exception: 0, Pending: 1
2014-05-28T05:29:22.392Z OK: 8, Exception: 0, Pending: 1
2014-05-28T05:29:23.392Z OK: 8, Exception: 0, Pending: 1
2014-05-28T05:29:24.394Z OK: 9, Exception: 0, Pending: 0

********** Failed Unit **********
    Test: root --> 
    Unit: 1+2+3=7
Expected: 7
  Actual: 6

********** Failed Unit **********
    Test: root --> 
    Unit: (obj.unit>1)=true
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

********** Failed Unit **********
    Test: root --> 
    Unit: {} is {}
Expected: {}
  Actual: {}

********** Failed Unit **********
    Test: root --> 
    Unit: [] is []
Expected: []
  Actual: []

********** Failed Unit **********
    Test: root --> 
    Unit: sampleNaN1=1
Expected: 1
  Actual: null

********** Failed Unit **********
    Test: root --> 
    Unit: NaN= 3
Expected: 3
  Actual: null

********** Failed Unit **********
    Test: root --> 
    Unit: '' =NaN
Expected: null
  Actual: ""

********** Failed Unit **********
    Test: root --> 
    Unit: 0=-0
Expected: 0
  Actual: 0

********** Failed Unit **********
    Test: root --> 
    Unit: 0 is -0
Expected: 0
  Actual: 0

********** Failed Unit **********
    Test: root --> 
    Unit: -0 is 0
Expected: 0
  Actual: 0

********** Failed Unit **********
    Test: root --> 
    Unit: b throws
Expected: exception
  Actual: no exception

********** Failed Unit **********
    Test: root --> 
    Unit: a throws /kkk/
Expected: an exception
  Actual: another exception

********** Failed Unit **********
    Test: root --> 
    Unit: a throws CustomError
Expected: an exception
  Actual: another exception

********** Failed Unit **********
    Test: root --> 
    Unit: a
Expected: no exception
  Actual: exception

Completed. 0 exceptional tests. 16 failed units.

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
    sampleNaN1 = NaN
    sampleNaN2 = NaN
    unit('sampleNaN1=sampleNaN2')
    unit('sampleNaN1=1')
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
    unit(' /=/.test("=")=true ')
    unit(' /=/.test("=")=false ')
    unit('Object .   is is Object.is')
    unit('Object.is = Object. is')
    unit(' "\\""="\\"abc" ')
    unit(' 123<>123 ')
    unit(' 123<>456 ')
    unit(' {a:1,b:2}<>{a:1,b:1} ')
    unit(' {a:1,b:2}<>{a:1,b:2} ')
    unit(' 8 isnt 4 ')
    unit(' NaN isnt NaN ')
    unit(' {} isnt {} ')
).run()
