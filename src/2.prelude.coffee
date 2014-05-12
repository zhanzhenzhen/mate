featureLoaders = []
$mate = {}
$mate.environmentType =
    if exports? and module?.exports?
        "node"
    else if window?
        "browser"
    else
        undefined
$mate.enableAllFeatures = ->
    global.$mate = $mate
    featureLoaders.forEach((m) -> m())
