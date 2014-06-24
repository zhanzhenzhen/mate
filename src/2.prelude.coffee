npmMate = {}
npmMate.environmentType =
    if exports? and module?.exports?
        "node"
    else if window?
        "browser"
    else
        undefined
