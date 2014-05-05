Mate is a small collection that extends JavaScript and CoffeeScript,
especially on `Array`.

Tutorial
====

[Visit author's website for tutorial!](http://zhanzhenzhen.github.io/project-tutorials/mate.xhtml)

Compile
====

I already compiled all files to JS. If you want to compile them on your own for learning purposes, first
make sure "coffee-script" and "uglify-js" packages have been installed globally, then go to this directory,
then type (suppose you're on Linux / Mac OS):

```bash
coffee -bp -j mate.js -c src/*.coffee | cat - src/package-start.txt package.json src/package-end.txt > mate.js && uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments && coffee -b -j test/compiled.js -c test/*.coffee && coffee -b -j test-test/compiled.js -c test-test/*.coffee
```
