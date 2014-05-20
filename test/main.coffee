# TODO: Lots of work needed! The `test` feature has just been added.

if exports? and module?.exports?
    require("../mate")
    assert = require("assert")
$mate.test.add([
    -> new Date("2014-02-03T18:19:25.987").equals(new Date("2014-02-03T18:19:25.987"))
    (state) ->
        class Obj
            constructor: ->
                @onClick = eventField()
            makeClick: -> @onClick.fire()
        obj = new Obj()
        obj.onClick.bind(-> state(true))
        obj.makeClick()
]).run()
