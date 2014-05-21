# TODO: Lots of work needed! The testing feature has just been added.

if exports? and module?.exports?
    require("../mate").enableAllFeatures()
Test = $mate.testing.Test
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
).run()
