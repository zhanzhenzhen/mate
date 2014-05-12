if $mate.environmentType == "browser"
    global.$mate = $mate
else if $mate.environmentType == "node"
    module.exports = $mate
else
    throw new Error()
