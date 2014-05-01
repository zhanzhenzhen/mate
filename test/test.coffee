###

This is to test the "test". The output should look something like that:

2014-04-30T16:46:18.638Z Success: 6, Failure: 3, Pending: 2
2014-04-30T16:46:19.634Z Success: 6, Failure: 4, Pending: 1
2014-04-30T16:46:20.631Z Success: 6, Failure: 4, Pending: 1
2014-04-30T16:46:21.625Z Success: 7, Failure: 4, Pending: 0
Completed.

Failure "simple test 1":
function () {
      return 1 + 2 + 3 === 7;
    }

Failure "simple test 1":
function () {
      return assert(false);
    }

Failure "simple test 1":
function () {
      throw new Error();
    }

Failure "Test_0":
function () {
    return true === false;
  }

###

require("../mate")
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
])
.add("simple test 2", (ctx) ->
    setTimeout(->
        ctx.state = true
    , 2500)
)
.add(->
    true == false
, 1000).run()
