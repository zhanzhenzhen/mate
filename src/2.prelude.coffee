featureLoaders = []
npmMate = {}
npmMate.testing = {}
npmMate.environmentType =
    if exports? and module?.exports?
        "node"
    else if window?
        "browser"
    else
        undefined
npmMate.enableAllFeatures = ->
    if npmMate.environmentType == "browser"
        window.global = window
    global.npmMate = npmMate
    featureLoaders.forEach((m) -> m())
