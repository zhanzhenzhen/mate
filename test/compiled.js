// Generated by CoffeeScript 1.8.0
(function() {
  var mate;

  mate = typeof npmMate !== "undefined" && npmMate !== null ? npmMate : require("../mate");

  new Test("root").add(function(my, I) {
    return I.wish(' new Date("2014-02-03T18:19:25.987").equals(new Date("2014-02-03T18:19:25.987"))=true ');
  }).add(function(my, I) {
    var Obj, obj;
    Obj = (function() {
      function Obj() {
        this.onClick = eventField();
      }

      Obj.prototype.makeClick = function() {
        return this.onClick.fire();
      };

      return Obj;

    })();
    obj = new Obj();
    obj.onClick.bind(function() {
      return I.end();
    });
    return obj.makeClick();
  }).add(function() {
    return console.logt(3);
  }).add("Object.is", function(my, I) {
    I.wish(' Object.is(5,5)=true ');
    I.wish(' Object.is(5,7)=false ');
    I.wish(' Object.is(0,-0)=false ');
    I.wish(' Object.is(0,0)=true ');
    I.wish(' Object.is(NaN,NaN)=true ');
    return I.wish(' Object.is({},{})=false ');
  }).add("Array::funReverse", function(my, I) {
    my.array = [3, 4, 5];
    my.reversed = my.array.funReverse();
    I.wish(' reversed=[5,4,3] ');
    return I.wish(' array=[3,4,5] ');
  }).run();

}).call(this);
