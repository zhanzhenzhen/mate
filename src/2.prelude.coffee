wishlist = require("wishlist")
npmMate = {}
npmMate.environmentType = wishlist.environmentType
npmMate.moduleSystem = wishlist.moduleSystem
if npmMate.environmentType == "browser"
    window.global = window
global.npmMate = npmMate
