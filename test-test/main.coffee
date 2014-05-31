###

This is to test the "test". The output should look something like this:

2014-05-31T11:37:05.548Z OK: 12, Exception: 0, Pending: 1
2014-05-31T11:37:06.544Z OK: 12, Exception: 0, Pending: 1
2014-05-31T11:37:07.545Z OK: 12, Exception: 0, Pending: 1
2014-05-31T11:37:08.545Z OK: 13, Exception: 0, Pending: 0

********** Failed Unit **********
    Test: root --> 
    Unit: var1=var2
Expected: = 1234
  Actual: 111

********** Failed Unit **********
    Test: root --> 
    Unit: 1+2+3=7
Expected: = 7
  Actual: 6

********** Failed Unit **********
    Test: root --> 
    Unit: (obj.unit>1)=true
Expected: = true
  Actual: false

********** Failed Unit **********
    Test: root --> nested test --> test 2 in nested test
    Unit: simple boolean test
Expected: = true
  Actual: false

********** Failed Unit **********
    Test: root --> nested var
    Unit: var1 is var2
Expected: is 8888
  Actual: 111

********** Failed Unit **********
    Test: root --> nested var --> 
    Unit: var1=var2
Expected: = 8888
  Actual: 111

********** Failed Unit **********
    Test: root --> 
    Unit: ("1"===2)=true
Expected: = true
  Actual: false

********** Failed Unit **********
    Test: root --> 
    Unit: {} is {}
Expected: is {}
  Actual: {}

********** Failed Unit **********
    Test: root --> 
    Unit: [] is []
Expected: is []
  Actual: []

********** Failed Unit **********
    Test: root --> 
    Unit: null<>null
Expected: ≠ null
  Actual: null

********** Failed Unit **********
    Test: root --> 
    Unit: undefined<>undefined
Expected: ≠ undefined
  Actual: undefined

********** Failed Unit **********
    Test: root --> 
    Unit: sampleNaN1=1
Expected: = 1
  Actual: NaN

********** Failed Unit **********
    Test: root --> 
    Unit: NaN= 3
Expected: = 3
  Actual: NaN

********** Failed Unit **********
    Test: root --> 
    Unit: '' =NaN
Expected: = NaN
  Actual: ""

********** Failed Unit **********
    Test: root --> 
    Unit: 0=-0
Expected: = 0
  Actual: 0

********** Failed Unit **********
    Test: root --> 
    Unit: 0 is -0
Expected: is 0
  Actual: 0

********** Failed Unit **********
    Test: root --> 
    Unit: -0 is 0
Expected: is 0
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

********** Failed Unit **********
    Test: root --> 
    Unit: /=/.test("=")=false
Expected: = false
  Actual: true

********** Failed Unit **********
    Test: root --> 
    Unit: "\""="\"abc"
Expected: = "\"abc"
  Actual: "\""

********** Failed Unit **********
    Test: root --> 
    Unit: 123<>123
Expected: ≠ 123
  Actual: 123

********** Failed Unit **********
    Test: root --> 
    Unit: {a:1,b:2}<>{a:1,b:2}
Expected: ≠ {a:1,b:2}
  Actual: {a:1,b:2}

********** Failed Unit **********
    Test: root --> 
    Unit: NaN isnt NaN
Expected: isn't NaN
  Actual: NaN

********** Failed Unit **********
    Test: root --> 
    Unit: {a:1,b:2}={a:1,b:2,c:function(){}}
Expected: = {a:1,b:2,c:[Function]}
  Actual: {a:1,b:2}

********** Failed Unit **********
    Test: root --> 
    Unit: {a:{a:{a:{a:{}}}}}={a:{a:{a:{a:1}}}}
Expected: = {a:{a:{a:[Object]}}}
  Actual: {a:{a:{a:[Object]}}}

********** Failed Unit **********
    Test: root --> 
    Unit: circularObj isnt circularObj
Expected: isn't {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}
  Actual: {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}

********** Failed Unit **********
    Test: root --> 
    Unit: circularObj <> circularObj
Expected: ≠ {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}
  Actual: {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}

********** Failed Unit **********
    Test: root --> 
    Unit: circularObj is circularObj2
Expected: is {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}
  Actual: {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}

********** Failed Unit **********
    Test: root --> 
    Unit: circularObj = circularObj2
Expected: = {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}
  Actual: {a:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}

********** Failed Unit **********
    Test: root --> 
    Unit: circularWrapper is circularWrapper2
Expected: is {content:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}
  Actual: {content:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}

********** Failed Unit **********
    Test: root --> 
    Unit: circularWrapper <> circularWrapper2
Expected: ≠ {content:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}
  Actual: {content:{a:{a:[Object],b:[Array]},b:[undefined,undefined]},b:[undefined,undefined]}

********** Failed Unit **********
    Test: root --> 
    Unit: veryLongCircularObj1=veryLongCircularObj2
Expected: = {me:[Object],secondMe:[Object],thirdMe:[Object],meArray:[Array],a:"............................................................",b:"............................................................",c:"............................................................",d:"............................................................",e:"............................................................",f:"............................................................",g:"............................................................",h:"............................................................",i:"............................................................",j:"............................................................",k:"............................................................",l:"............................................................",m:"............................................................",n:"............................................................"}
  Actual: {me:[Object],secondMe:[Object],thirdMe:[Object],meArray:[Array],a:"............................................................",b:"............................................................",c:"............................................................",d:"............................................................",e:"............................................................",f:"............................................................",g:"............................................................",h:"............................................................",i:"............................................................",j:"............................................................",k:"............................................................",l:"............................................................",m:"............................................................",n:"............................................................"}

********** Failed Unit **********
    Test: root --> 
    Unit: veryLongCircularObj1 is veryLongCircularObj2
Expected: is {me:[Object],secondMe:[Object],thirdMe:[Object],meArray:[Array],a:"............................................................",b:"............................................................",c:"............................................................",d:"............................................................",e:"............................................................",f:"............................................................",g:"............................................................",h:"............................................................",i:"............................................................",j:"............................................................",k:"............................................................",l:"............................................................",m:"............................................................",n:"............................................................"}
  Actual: {me:[Object],secondMe:[Object],thirdMe:[Object],meArray:[Array],a:"............................................................",b:"............................................................",c:"............................................................",d:"............................................................",e:"............................................................",f:"............................................................",g:"............................................................",h:"............................................................",i:"............................................................",j:"............................................................",k:"............................................................",l:"............................................................",m:"............................................................",n:"............................................................"}

0 Exceptional Tests, 36 Failed Units, Mark: 687f2

###

if exports? and module?.exports?
    Test = require("../mate").testing.Test
    global.unitsomething = -> true
else
    Test = $mate.testing.Test
    window.unitsomething = -> true
new Test("root"
).define((env) ->
    env.var1 = 111
    env.var2 = 1234
).add("String.prototype test", ->
    str = "hello world"
    unit(' str.substr(4,1)="o" ')
    unit(' str.split(" ")=["hello","world"] ')
    unit(' str.split(" ")=["hello","world"] ')
    unitsomething()
).add(->
    unit('Math.round(5.3)=5')
    unit('var1=var2')
    unit('var1<>var2')
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
).add(
    new Test("nested var"
    ).add(->
        unit('var1=var2')
    ).add(->
        unit('var1<>var2')
    ).define((env) ->
        env.var2 = 8888
    ).set(->
        unit('var1 is var2')
        unit('var1 isnt var2')
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
    unit("null<>null")
    unit("undefined<>undefined")
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
    unit(' {a:1,b:2}<>{a:1,b:2,c:function(){}} ')
    unit(' 8 isnt 4 ')
    unit(' NaN isnt NaN ')
    unit(' {} isnt {} ')
    # circular ----------------------------------------[
    unit(' {a:1,b:2}={a:1,b:2,c:function(){}} ')
    unit(' {a:{a:{a:{a:{}}}}}={a:{a:{a:{a:{}}}}} ')
    unit(' {a:{a:{a:{a:{}}}}}={a:{a:{a:{a:1}}}} ')
    circularObj = {}
    circularObj.a = circularObj
    circularObj.b = [3, 4]
    circularObj2 = {}
    circularObj2.a = circularObj2
    circularObj2.b = [3, 4]
    unit(' circularObj isnt circularObj ')
    unit(' circularObj is circularObj ')
    unit(' circularObj = circularObj ')
    unit(' circularObj <> circularObj ')
    unit(' circularObj isnt circularObj2 ')
    unit(' circularObj is circularObj2 ')
    unit(' circularObj = circularObj2 ')
    unit(' circularObj <> circularObj2 ')
    circularWrapper = {}
    circularWrapper.content = circularObj
    circularWrapper.b = [5, 6]
    circularWrapper2 = {}
    circularWrapper2.content = circularObj
    circularWrapper2.b = [5, 6]
    unit(' circularWrapper isnt circularWrapper2 ')
    unit(' circularWrapper is circularWrapper2 ')
    unit(' circularWrapper = circularWrapper2 ')
    unit(' circularWrapper <> circularWrapper2 ')
    # ]----------------------------------------
).add(->
    veryLongCircularObj1 = {}
    veryLongCircularObj1.me = veryLongCircularObj1
    veryLongCircularObj1.secondMe = veryLongCircularObj1
    veryLongCircularObj1.thirdMe = veryLongCircularObj1
    veryLongCircularObj1.meArray = [veryLongCircularObj1, veryLongCircularObj1]
    veryLongCircularObj1.a = "............................................................"
    veryLongCircularObj1.b = "............................................................"
    veryLongCircularObj1.c = "............................................................"
    veryLongCircularObj1.d = "............................................................"
    veryLongCircularObj1.e = "............................................................"
    veryLongCircularObj1.f = "............................................................"
    veryLongCircularObj1.g = "............................................................"
    veryLongCircularObj1.h = "............................................................"
    veryLongCircularObj1.i = "............................................................"
    veryLongCircularObj1.j = "............................................................"
    veryLongCircularObj1.k = "............................................................"
    veryLongCircularObj1.l = "............................................................"
    veryLongCircularObj1.m = "............................................................"
    veryLongCircularObj1.n = "............................................................"
    veryLongCircularObj2 = {}
    veryLongCircularObj2.me = veryLongCircularObj2
    veryLongCircularObj2.secondMe = veryLongCircularObj2
    veryLongCircularObj2.thirdMe = veryLongCircularObj2
    veryLongCircularObj2.meArray = [veryLongCircularObj2, veryLongCircularObj2]
    veryLongCircularObj2.a = "............................................................"
    veryLongCircularObj2.b = "............................................................"
    veryLongCircularObj2.c = "............................................................"
    veryLongCircularObj2.d = "............................................................"
    veryLongCircularObj2.e = "............................................................"
    veryLongCircularObj2.f = "............................................................"
    veryLongCircularObj2.g = "............................................................"
    veryLongCircularObj2.h = "............................................................"
    veryLongCircularObj2.i = "............................................................"
    veryLongCircularObj2.j = "............................................................"
    veryLongCircularObj2.k = "............................................................"
    veryLongCircularObj2.l = "............................................................"
    veryLongCircularObj2.m = "............................................................"
    veryLongCircularObj2.n = "............................................................"
    unit('veryLongCircularObj1=veryLongCircularObj2')
    unit('veryLongCircularObj1<>veryLongCircularObj2')
    unit('veryLongCircularObj1 is veryLongCircularObj2')
    unit('veryLongCircularObj1 isnt veryLongCircularObj2')
).run()
