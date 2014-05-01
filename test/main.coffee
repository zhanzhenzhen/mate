# TODO: Lots of work needed! The `test` feature has just been added.

require("../mate")
$mate.test.add([
    -> new Date("2014-02-03T18:19:25.987").equals(new Date("2014-02-03T18:19:25.987"))
]).run()
