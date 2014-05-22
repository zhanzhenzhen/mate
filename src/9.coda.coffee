if $mate.environmentType == "browser"
    window.$mate = $mate
else if $mate.environmentType == "node"
    module.exports = $mate
else
    throw new Error()
