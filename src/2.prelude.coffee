featureLoaders = []
$mate = {}
$mate.testing = {}
$mate.environmentType =
    if exports? and module?.exports?
        "node"
    else if window?
        "browser"
    else
        undefined
$mate.enableAllFeatures = ->
    if $mate.environmentType == "browser"
        window.global = window
    global.$mate = $mate
    featureLoaders.forEach((m) -> m())
