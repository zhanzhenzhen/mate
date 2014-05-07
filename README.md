Mate is your JavaScript/CoffeeScript mate that brings these key features:

- Class Events
- Array Extensions
- Advanced Timers
- "Functional" Functions
- Complex Math
- Unit Test
- ECMAScript 6th Features

Mate performs consistently in all modern browsers and node.js.

Tutorial
====

[Visit author's website for tutorial!](http://zhanzhenzhen.github.io/project-tutorials/mate/)

Compile
====

(This section is only for the author of this repo, so other developers can just ignore it. Also note: This compilation method is for Linux / Mac OS.)

Before commiting a release version of this project, code files must be compiled by following these steps:

First, make sure "coffee-script" v1.6.3 and "uglify-js" v2.4.13 node packages have been installed GLOBALLY.

Then, in Terminal, go to the repo's directory, and type:

```bash
coffee -bp -j mate.js -c src/*.coffee | cat - src/package-start.txt package.json src/package-end.txt > mate.js && uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments && coffee -b -j test/compiled.js -c test/*.coffee && coffee -b -j test-test/compiled.js -c test-test/*.coffee
```
