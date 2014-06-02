Mate
====

Mate is your JavaScript/CoffeeScript mate that brings these key features:

- Very natural unit testing
- A new way of handling events
- Array extensions
- Advanced timers
- "Functional" functions
- 2D point & complex Math
- ECMAScript 6th features

Mate performs consistently in all modern browsers and node.js.

Tutorial
====

[Tutorial](http://zhanzhenzhen.github.io/mate/)

[教程](http://zhanzhenzhen.github.io/mate/)

[Lernprogramm](http://zhanzhenzhen.github.io/mate/)

[チュートリアル](http://zhanzhenzhen.github.io/mate/)

[Didacticiel](http://zhanzhenzhen.github.io/mate/)

Compile & Publish
====

This section is only for the author of this repo, so other developers can just ignore it.

**How to compile**

```bash
awk 'FNR==1{print ""}1' src/*.coffee src/package-start.txt package.json src/package-end.txt | node_modules/coffee-script/bin/coffee -cs > mate.js && node_modules/uglify-js/bin/uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments && awk 'FNR==1{print ""}1' test/*.coffee | node_modules/coffee-script/bin/coffee -cs > test/compiled.js && awk 'FNR==1{print ""}1' test-test/*.coffee | node_modules/coffee-script/bin/coffee -cs > test-test/compiled.js
```

**How to publish**

The compiled .js files should ONLY be included in the tagged commits. To achieve this goal, we put the release version into a new branch and then delete the branch. This approach makes sense because Git's gc does not delete tagged commits, regardless of whether a branch refers to it. Detailed steps:

First, make sure all changes are recorded in master branch. Then, compile. Then:

```bash
git checkout -b release && git add -f mate.js mate.min.js test/compiled.js test-test/compiled.js
```

Then commit it and tag it and push it and push tags. Then:

```bash
npm publish . && git checkout master && git branch -D release
```
