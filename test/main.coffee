# TODO: Lots of work needed!

mate = npmMate ? require("../mate")
new Test("root"
).add((my, I) ->
    I.wish(' new Date("2014-02-03T18:19:25.987").equals(new Date("2014-02-03T18:19:25.987"))=true ')
).add((my, I) ->
    class Obj
        constructor: ->
            @onClick = eventField()
        makeClick: -> @onClick.fire()
    obj = new Obj()
    obj.onClick.bind(-> I.end())
    obj.makeClick()
).add(->
    console.logt(3)
).add("Object.is", (my, I) ->
    I.wish(' Object.is(5,5)=true ')
    I.wish(' Object.is(5,7)=false ')
    I.wish(' Object.is(0,-0)=false ')
    I.wish(' Object.is(0,0)=true ')
    I.wish(' Object.is(NaN,NaN)=true ')
    I.wish(' Object.is({},{})=false ')
).run()
