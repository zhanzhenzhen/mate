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

require("../mate") if exports? and module?.exports?
$mate.test.add("simple test 1", [
    -> 1 + 2 + 3 == 6
    -> 1 + 2 + 3 == 7
    -> "hello".substr(1, 1) == "e"
    -> assert(true)
    -> assert(false)
    ->
    -> undefined
    -> null
    -> throw new Error()
]).add("simple test 2", (state) ->
    setTimeout(->
        state(true)
    , 2500)
).add(->
    true == false
, 1000).run()
