# TODO: Lots of work needed! The testing feature has just been added.

if exports? and module?.exports?
    require("../mate").enableAllFeatures()
else
    npmMate.enableAllFeatures()
new Test("root"
).add(->
    unit(' new Date("2014-02-03T18:19:25.987").equals(new Date("2014-02-03T18:19:25.987"))=true ')
).add(->
    class Obj
        constructor: ->
            @onClick = eventField()
        makeClick: -> @onClick.fire()
    obj = new Obj()
    obj.onClick.bind(-> finish())
    obj.makeClick()
).add(->
    console.logt(3)
).add("Object.is", ->
    unit(' Object.is(5,5)=true ')
    unit(' Object.is(5,7)=false ')
    unit(' Object.is(0,-0)=false ')
    unit(' Object.is(0,0)=true ')
    unit(' Object.is(NaN,NaN)=true ')
    unit(' Object.is({},{})=false ')
).run()
