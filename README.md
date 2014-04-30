Mate is a small collection that extends JavaScript and CoffeeScript,
especially on `Array`.

    require("mate");

I already compiled all files to "mate.js". If you want to compile it on your own for learning purposes, first
make sure "coffee-script" and "uglify-js" packages have been installed globally, then go to this directory,
then type:

    coffee -bp -j mate.js -c src/*.coffee | cat - src/package-start.txt package.json src/package-end.txt > mate.js

Then type:

    uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments

[Visit author's website for tutorial!](http://zhanzhenzhen.com/#mate)
