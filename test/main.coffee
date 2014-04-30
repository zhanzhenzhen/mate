require("../mate.min")
$mate.test.add([
    -> [2, 3, 4].sum() == 9
    -> [5, 6, 7].sum() == 17
])
$mate.test.add("simple test 2", (ctx) ->
    setTimeout(->
        ctx.state = Math.random() < 0.5
    , 2500)
)
$mate.test.run()
console.log($mate.nodePackageInfo.version)
