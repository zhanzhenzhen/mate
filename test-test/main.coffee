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

global.equall = -> true
if exports? and module?.exports?
    $mate = require("../mate")
    Test = $mate.testing.Test
new Test("root"
).add("String.prototype test", ->
    str = "hello world"
    equal(str.substr(4, 1), "o", "substr method")
    equal(str.split(" "), ["hello", "world"])
    unit(' str.substr(4,1)="o" ')
    unit(' str.split(" ")=["hello","world"] ')
    unit(' str.split(" ")=["hello","world"] ')
    equall()
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
        equal(true, true, "truthy unit")
        finish()
    , 2500)
).add(->
    unit("(\"1\"===2)=true")
).run()
