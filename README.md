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

Before publishing it to npmjs.org, we must compile code files by following these steps:

First, make sure "coffee-script" v1.7.1 and "uglify-js" v2.4.13 node packages have been installed GLOBALLY.

Then, in Terminal, go to the repo's directory, and type:

```bash
awk 'FNR==1{print ""}1' src/*.coffee src/package-start.txt package.json src/package-end.txt | coffee -cs > mate.js && uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments && awk 'FNR==1{print ""}1' test/*.coffee | coffee -cs > test/compiled.js && awk 'FNR==1{print ""}1' test-test/*.coffee | coffee -cs > test-test/compiled.js
```
