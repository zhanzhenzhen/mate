Mate
====

Mate is your JavaScript/CoffeeScript mate that brings these key features:

- Unit Testing
- Class Events
- Array Extensions
- Advanced Timers
- "Functional" Functions
- Complex Math
- ECMAScript 6th Features

Mate performs consistently in all modern browsers and node.js.

Comparison
====

<table>
    <tr>
        <th>Traditional Way</th>
        <th>Mate</th>
    </tr>
    <tr>
        <td>
            Unit testing (using "Vows"):
            <pre>
vows.describe("root").addBatch(
  "String methods":
    topic: -&gt;
      "hello world"
    'charAt(3) returns "l"':
     (topic) -&gt;
      assert.strictEqual(
        topic.charAt(3), "l")
    'substr(6,3) returns "wor"':
     (topic) -&gt;
      assert.strictEqual(
        topic.substr(6, 3), "wor")
)</pre>
        </td>
        <td><pre>
new Test("root")
.add("String methods", -&gt;
  s = "hello world"
  unit(' s.charAt(3)="l" ')
  unit(' s.substr(6,3)="wor" ')
)</pre>
        </td>
    </tr>
    <tr>
        <td>
            Check if a string starts with a substring:
            <pre>"hey you".indexOf("hey") == 0</pre>
            Or use "Underscore.js":
            <pre>_.str.startsWith("hey you", "hey")</pre>
        </td>
        <td><pre>"hey you".startsWith("hey")</pre></td>
    </tr>
    <tr>
        <td>
            Let <i>myArray</i> be [0,0,0,...] (length=100)
            <pre>myArray = (0 for i in [0...100])</pre>
        </td>
        <td><pre>myArray = spread(0, 100)</pre></td>
    </tr>
    <tr>
        <td>
            Let <i>time</i> be 5 seconds after the current time.
            <pre>time = new Date(new Date().getTime()
  + 5000)</pre>
            or
            <pre>time = new Date(Date.now() + 5000)</pre>
            or
            <pre>time = new Date(new Date()
  - (-5000))</pre>
        </td>
        <td><pre>time = new Date().add(5000)</pre></td>
    </tr>
    <tr>
        <td>
            Let it throw an error.
            <pre>throw new Error()</pre>
        </td>
        <td><pre>fail()</pre></td>
    </tr>
    <tr>
        <td>...　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　</td>
        <td>...　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　</td>
    </tr>
</table>

Tutorial
====

[Visit author's website for tutorial!](http://zhanzhenzhen.github.io/project-tutorials/mate/)
----

Compile
====

(This section is only for the author of this repo, so other developers can just ignore it. Also note: This compilation method is for Linux / Mac OS.)

Before publishing it to npmjs.org, we must compile code files by following these steps:

First, make sure "coffee-script" v1.7.1 and "uglify-js" v2.4.13 node packages have been installed GLOBALLY.

Then, in Terminal, go to the repo's directory, and type:

```bash
awk 'FNR==1{print ""}1' src/*.coffee src/package-start.txt package.json src/package-end.txt | coffee -cs > mate.js && uglifyjs mate.js -o mate.min.js -m --screw-ie8 --comments && awk 'FNR==1{print ""}1' test/*.coffee | coffee -cs > test/compiled.js && awk 'FNR==1{print ""}1' test-test/*.coffee | coffee -cs > test-test/compiled.js
```
