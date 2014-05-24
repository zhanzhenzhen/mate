Mate
====

Mate is your JavaScript/CoffeeScript mate that brings these key features:

- A New Way of Unit Testing
- A New Way of Handling Events
- Array Extensions
- Advanced Timers
- "Functional" Functions
- Complex Math
- ECMAScript 6th Features

Mate performs consistently in all modern browsers and node.js.

Tutorial
====

[Please click here for tutorial.](http://zhanzhenzhen.github.io/project-tutorials/mate/)

Compile & Publish
====

This section is only for the author of this repo, so other developers can just ignore it.

**How to compile**

```bash
awk 'FNR==1{print ""}1' src/*.coffee src/package-start.txt package.json src/package-end.txt | node_modules/coffee-script/bin/coffee -cs > mate.js && node_modules/uglify-js/bin/uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments && awk 'FNR==1{print ""}1' test/*.coffee | node_modules/coffee-script/bin/coffee -cs > test/compiled.js && awk 'FNR==1{print ""}1' test-test/*.coffee | node_modules/coffee-script/bin/coffee -cs > test-test/compiled.js
```

**How to publish**

The compiled .js files should ONLY be included in the tagged commits. To achieve this goal, we put the release version into a new branch and then delete the branch. This approach makes sense because Git's gc does not delete tagged commits, regardless of whether a branch refers to it. Detailed steps:

First, compile. Then:

```bash
git checkout -b release && git add -f mate.js mate.min.js test/compiled.js test-test/compiled.js
```

Then commit it and tag it and push it and push tags. Then:

```bash
npm publish . && git checkout master && git branch -D release
```
