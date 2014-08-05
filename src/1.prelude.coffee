wishlist = require("wishlist")
mate = {}
mate.packageInfo = require("./package.json")
mate.environmentType = wishlist.environmentType
mate.moduleSystem = wishlist.moduleSystem
if mate.environmentType == "browser"
    window.global = window
global.npmMate = mate
