if npmMate.environmentType == "browser"
    window.npmMate = npmMate
else if npmMate.environmentType == "node"
    module.exports = npmMate
else
    throw new Error()
