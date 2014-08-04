wishlist = require("wishlist")
npmMate = {}
npmMate.packageInfo = require("./package.json")
npmMate.environmentType = wishlist.environmentType
npmMate.moduleSystem = wishlist.moduleSystem
if npmMate.environmentType == "browser"
    window.global = window
global.npmMate = npmMate
