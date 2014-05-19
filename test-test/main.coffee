###

This is to test the "test". The output should look something like that:

2014-05-02T09:32:42.933Z Success: 6, Failure: 3, Pending: 2
2014-05-02T09:32:43.931Z Success: 6, Failure: 4, Pending: 1
2014-05-02T09:32:44.933Z Success: 6, Failure: 4, Pending: 1
2014-05-02T09:32:45.934Z Success: 7, Failure: 4, Pending: 0

Failure "simple test 1":
function () {
      return 1 + 2 + 3 === 7;
    }

Failure "simple test 1":
function () {
      return assert(false);
    }
...

Failure "simple test 1":
function () {
      throw new Error();
    }
...

Failure "Test_0":
function () {
    return true === false;
  }

Completed. 4 failures.

###

if exports? and module?.exports?
    $mate = require("../mate")
    Test = $mate.testing.Test
new Test().add("String.prototype test", ->
    str = "hello world"
    equal(str.substr(4, 1), "o", "substr method")
    equal(str.split(" "), ["hello", "world"])
    unit(' str.substr(4,1)="o" ')
    unit(' str.split(" ")=["hello","world"] ')
).add((t) ->
    equal(Math.round(5.3), 5)
).add((t) ->
    equal(1 + 2 + 3, 7)
).add(
    new Test("nested test").add("test 1 in nested test", ->
        equal(false, false)
    ).add("test 2 in nested test", ->
        equal(false, true)
    )
).addAsync("simple test 2", ->
    setTimeout(->
        equal(true, true, "truthy unit")
        end()
    , 2500)
).add(->
    unit("(1===2)=true")
).run()
