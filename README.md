Mate is your JavaScript/CoffeeScript mate that brings these key features:

- Class Events
- Array Extensions
- Advanced Timers
- "Functional" Functions
- Complex Math
- ECMAScript 6th Features

Mate performs consistently in all modern browsers and node.js.

Tutorial
====

[Visit author's website for tutorial!](http://zhanzhenzhen.github.io/project-tutorials/mate/)

Compile
====

I already compiled everything to 2 files: "mate.js" and "mate.min.js", so you don't need to compile on your own. But if you want to do it for learning purposes, follow these steps (suppose you're on Linux / Mac OS):

First, make sure "coffee-script" and "uglify-js" packages have been installed globally.

Then, open the terminal, go to the project directory, and type:

```bash
coffee -bp -j mate.js -c src/*.coffee | cat - src/package-start.txt package.json src/package-end.txt > mate.js && uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments && coffee -b -j test/compiled.js -c test/*.coffee && coffee -b -j test-test/compiled.js -c test-test/*.coffee
```
