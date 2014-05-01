// Generated by CoffeeScript 1.6.3
/* @preserve
Mate
https://github.com/zhanzhenzhen/mate
(c) 2013 Zhenzhen Zhan
Mate may be freely distributed under the MIT license.
*/

var $mate, ArrayLazyWrapper, ObjectWithEvents, Point, assert, clearAdvancedInterval, cmath, compose, fail, repeat, setAdvancedInterval, spread,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

ArrayLazyWrapper = (function() {
  function ArrayLazyWrapper(value, chainToCopy, itemToPush) {
    var _this = this;
    this._value = value;
    this._chain = (chainToCopy != null ? chainToCopy : []).slice(0);
    if (itemToPush != null) {
      this._chain.push(itemToPush);
    }
    Object.getter(this, "length", function() {
      return _this.force().length;
    });
  }

  ArrayLazyWrapper.prototype.force = function() {
    var m, n, _i, _len, _ref;
    n = this._value;
    _ref = this._chain;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      m = _ref[_i];
      n = m.fun.apply(n, m.args);
    }
    return n;
  };

  ArrayLazyWrapper.prototype.map = function() {
    return this._pushChain(Array.prototype.map, arguments);
  };

  ArrayLazyWrapper.prototype.filter = function() {
    return this._pushChain(Array.prototype.filter, arguments);
  };

  ArrayLazyWrapper.prototype.concat = function() {
    return this._pushChain(Array.prototype.concat, arguments);
  };

  ArrayLazyWrapper.prototype.portion = function() {
    return this._pushChain(Array.prototype.portion, arguments);
  };

  ArrayLazyWrapper.prototype.funSort = function() {
    return this._pushChain(Array.prototype.funSort, arguments);
  };

  ArrayLazyWrapper.prototype.funSortDescending = function() {
    return this._pushChain(Array.prototype.funSortDescending, arguments);
  };

  ArrayLazyWrapper.prototype.funReverse = function() {
    return this._pushChain(Array.prototype.funReverse, arguments);
  };

  ArrayLazyWrapper.prototype.except = function() {
    return this._pushChain(Array.prototype.except, arguments);
  };

  ArrayLazyWrapper.prototype.group = function() {
    return this._pushChain(Array.prototype.group, arguments);
  };

  ArrayLazyWrapper.prototype.flatten = function() {
    return this._pushChain(Array.prototype.flatten, arguments);
  };

  ArrayLazyWrapper.prototype.random = function() {
    return this._pushChain(Array.prototype.random, arguments);
  };

  ArrayLazyWrapper.prototype.some = function() {
    return this._unwrapAndDo(Array.prototype.some, arguments);
  };

  ArrayLazyWrapper.prototype.every = function() {
    return this._unwrapAndDo(Array.prototype.every, arguments);
  };

  ArrayLazyWrapper.prototype.isEmpty = function() {
    return this._unwrapAndDo(Array.prototype.isEmpty, arguments);
  };

  ArrayLazyWrapper.prototype.at = function() {
    return this._unwrapAndDo(Array.prototype.at, arguments);
  };

  ArrayLazyWrapper.prototype.atOrNull = function() {
    return this._unwrapAndDo(Array.prototype.atOrNull, arguments);
  };

  ArrayLazyWrapper.prototype.contains = function() {
    return this._unwrapAndDo(Array.prototype.contains, arguments);
  };

  ArrayLazyWrapper.prototype.first = function() {
    return this._unwrapAndDo(Array.prototype.first, arguments);
  };

  ArrayLazyWrapper.prototype.firstOrNull = function() {
    return this._unwrapAndDo(Array.prototype.firstOrNull, arguments);
  };

  ArrayLazyWrapper.prototype.last = function() {
    return this._unwrapAndDo(Array.prototype.last, arguments);
  };

  ArrayLazyWrapper.prototype.lastOrNull = function() {
    return this._unwrapAndDo(Array.prototype.lastOrNull, arguments);
  };

  ArrayLazyWrapper.prototype.single = function() {
    return this._unwrapAndDo(Array.prototype.single, arguments);
  };

  ArrayLazyWrapper.prototype.singleOrNull = function() {
    return this._unwrapAndDo(Array.prototype.singleOrNull, arguments);
  };

  ArrayLazyWrapper.prototype.withMax = function() {
    return this._unwrapAndDo(Array.prototype.withMax, arguments);
  };

  ArrayLazyWrapper.prototype.withMin = function() {
    return this._unwrapAndDo(Array.prototype.withMin, arguments);
  };

  ArrayLazyWrapper.prototype.max = function() {
    return this._unwrapAndDo(Array.prototype.max, arguments);
  };

  ArrayLazyWrapper.prototype.min = function() {
    return this._unwrapAndDo(Array.prototype.min, arguments);
  };

  ArrayLazyWrapper.prototype.sum = function() {
    return this._unwrapAndDo(Array.prototype.sum, arguments);
  };

  ArrayLazyWrapper.prototype.average = function() {
    return this._unwrapAndDo(Array.prototype.average, arguments);
  };

  ArrayLazyWrapper.prototype.median = function() {
    return this._unwrapAndDo(Array.prototype.median, arguments);
  };

  ArrayLazyWrapper.prototype.product = function() {
    return this._unwrapAndDo(Array.prototype.product, arguments);
  };

  ArrayLazyWrapper.prototype.randomOne = function() {
    return this._unwrapAndDo(Array.prototype.randomOne, arguments);
  };

  ArrayLazyWrapper.prototype._pushChain = function(fun, args) {
    return new ArrayLazyWrapper(this._value, this._chain, {
      fun: fun,
      args: args
    });
  };

  ArrayLazyWrapper.prototype._unwrapAndDo = function(fun, args) {
    return fun.apply(this.force(), args);
  };

  return ArrayLazyWrapper;

})();

Array._elementOrUseSelector = function(element, selector) {
  if (selector != null) {
    return selector(element);
  } else {
    return element;
  }
};

Array.prototype._numberToIndex = function(pos) {
  if ((0 < pos && pos < 1)) {
    return pos = Math.round(pos * (this.length - 1));
  } else {
    return pos;
  }
};

Array.prototype._numberToLength = function(pos) {
  if ((0 < pos && pos < 1)) {
    return pos = Math.round(pos * this.length);
  } else {
    return pos;
  }
};

Array.prototype.copy = function() {
  return this.slice(0);
};

Array.prototype.isEmpty = function() {
  return this.length === 0;
};

Array.prototype.lazy = function() {
  return new ArrayLazyWrapper(this);
};

Array.prototype.portion = function(startIndex, length, endIndex) {
  if (Number.isFraction(startIndex) || Number.isFraction(length) || Number.isFraction(endIndex)) {
    if (startIndex === 0) {
      startIndex = 0 + Number.EPSILON;
    }
    if (startIndex === 1) {
      startIndex = 1 - Number.EPSILON;
    }
    if (length === 0) {
      length = 0 + Number.EPSILON;
    }
    if (length === 1) {
      length = 1 - Number.EPSILON;
    }
    if (endIndex === 0) {
      endIndex = 0 + Number.EPSILON;
    }
    if (endIndex === 1) {
      endIndex = 1 - Number.EPSILON;
    }
  }
  startIndex = this._numberToIndex(startIndex);
  length = this._numberToLength(length);
  endIndex = this._numberToIndex(endIndex);
  return this.slice(startIndex, length != null ? startIndex + length : endIndex + 1);
};

Array.prototype.at = function(index) {
  index = this._numberToIndex(index);
  assert((0 <= index && index < this.length));
  return this[index];
};

Array.prototype.atOrNull = function(index) {
  try {
    return this.at(index);
  } catch (_error) {
    return null;
  }
};

Array.prototype.contains = function(value) {
  return __indexOf.call(this, value) >= 0;
};

Array.prototype.first = function(predicate) {
  var queryResult;
  queryResult = predicate != null ? this.filter(predicate) : this;
  return queryResult.at(0);
};

Array.prototype.firstOrNull = function(predicate) {
  try {
    return this.first(predicate);
  } catch (_error) {
    return null;
  }
};

Array.prototype.last = function(predicate) {
  var queryResult;
  queryResult = predicate != null ? this.filter(predicate) : this;
  return queryResult.at(queryResult.length - 1);
};

Array.prototype.lastOrNull = function(predicate) {
  try {
    return this.last(predicate);
  } catch (_error) {
    return null;
  }
};

Array.prototype.single = function(predicate) {
  var queryResult;
  queryResult = predicate != null ? this.filter(predicate) : this;
  assert(queryResult.length === 1);
  return queryResult.at(0);
};

Array.prototype.singleOrNull = function(predicate) {
  try {
    return this.single(predicate);
  } catch (_error) {
    return null;
  }
};

Array.prototype.withMax = function(selector) {
  var _this = this;
  return this.reduce(function(a, b, index) {
    if (Array._elementOrUseSelector(a, selector) > Array._elementOrUseSelector(b, selector)) {
      return a;
    } else {
      return b;
    }
  });
};

Array.prototype.withMin = function(selector) {
  var _this = this;
  return this.reduce(function(a, b, index) {
    if (Array._elementOrUseSelector(a, selector) < Array._elementOrUseSelector(b, selector)) {
      return a;
    } else {
      return b;
    }
  });
};

Array.prototype.max = function(selector) {
  return Array._elementOrUseSelector(this.withMax(selector), selector);
};

Array.prototype.min = function(selector) {
  return Array._elementOrUseSelector(this.withMin(selector), selector);
};

Array.prototype.sum = function(selector) {
  var _this = this;
  if (this.length === 1) {
    return Array._elementOrUseSelector(this.first(), selector);
  } else {
    return this.reduce(function(a, b, index) {
      return (index === 1 ? Array._elementOrUseSelector(a, selector) : a) + Array._elementOrUseSelector(b, selector);
    });
  }
};

Array.prototype.average = function(selector) {
  return this.sum(selector) / this.length;
};

Array.prototype.median = function(selector) {
  var a, b, m, n, sorted;
  sorted = this.funSort(selector);
  a = sorted.at(0.5 - Number.EPSILON);
  b = sorted.at(0.5 + Number.EPSILON);
  m = Array._elementOrUseSelector(a, selector);
  n = Array._elementOrUseSelector(b, selector);
  return (m + n) / 2;
};

Array.prototype.product = function(selector) {
  var _this = this;
  if (this.length === 1) {
    return Array._elementOrUseSelector(this.first(), selector);
  } else {
    return this.reduce(function(a, b, index) {
      return (index === 1 ? Array._elementOrUseSelector(a, selector) : a) * Array._elementOrUseSelector(b, selector);
    });
  }
};

Array.prototype.group = function(keySelector, resultSelector) {
  var comparedKey, elements, groups, key, m, sorted, _i, _len;
  if (this.isEmpty()) {
    return [];
  }
  sorted = this.funSort(keySelector);
  groups = [];
  comparedKey = Array._elementOrUseSelector(sorted.first(), keySelector);
  elements = [];
  for (_i = 0, _len = sorted.length; _i < _len; _i++) {
    m = sorted[_i];
    key = Array._elementOrUseSelector(m, keySelector);
    if (key !== comparedKey) {
      groups.push({
        key: comparedKey,
        result: Array._elementOrUseSelector(elements, resultSelector)
      });
      comparedKey = key;
      elements = [];
    }
    elements.push(m);
  }
  groups.push({
    key: comparedKey,
    result: Array._elementOrUseSelector(elements, resultSelector)
  });
  return groups;
};

Array.prototype._sort = function(keySelector, isDescending) {
  var _this = this;
  return this.copy().sort(function(a, b) {
    var a1, b1;
    a1 = Array._elementOrUseSelector(a, keySelector);
    b1 = Array._elementOrUseSelector(b, keySelector);
    if (a1 < b1) {
      if (isDescending) {
        return 1;
      } else {
        return -1;
      }
    } else if (a1 > b1) {
      if (isDescending) {
        return -1;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  });
};

Array.prototype.funSort = function(keySelector) {
  return this._sort(keySelector, false);
};

Array.prototype.funSortDescending = function(keySelector) {
  return this._sort(keySelector, true);
};

Array.prototype.funReverse = function() {
  return this.copy().reverse();
};

Array.prototype.except = function(array) {
  return this.filter(function(m) {
    return __indexOf.call(array, m) < 0;
  });
};

Array.prototype.flatten = function(level) {
  var canContinue, m, n, r, _i, _j, _len, _len1;
  if (level <= 0) {
    return fail();
  } else {
    r = [];
    canContinue = false;
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      m = this[_i];
      if (Array.isArray(m)) {
        canContinue = true;
        for (_j = 0, _len1 = m.length; _j < _len1; _j++) {
          n = m[_j];
          r.push(n);
        }
      } else {
        r.push(m);
      }
    }
    if (canContinue) {
      if (level != null) {
        if (level === 1) {
          return r;
        } else {
          return r.flatten(level - 1);
        }
      } else {
        return r.flatten();
      }
    } else {
      return r;
    }
  }
};

Array.prototype.randomOne = function() {
  return this[Math.randomInt(this.length)];
};

Array.prototype.random = function(count) {
  return this.copy().takeRandom(count);
};

Array.prototype.takeRandomOne = function() {
  var index, r;
  index = Math.randomInt(this.length);
  r = this[index];
  this.removeAt(index);
  return r;
};

Array.prototype.takeRandom = function(count) {
  var _this = this;
  if (count == null) {
    count = this.length;
  }
  count = this._numberToLength(count);
  return repeat(count, function() {
    return _this.takeRandomOne();
  });
};

Array.prototype.removeAt = function(index) {
  this.splice(index, 1);
  return this;
};

Array.prototype.remove = function(element) {
  var index;
  index = this.indexOf(element);
  assert(index > -1);
  return this.removeAt(index);
};

Array.prototype.removeAll = function(element) {
  var index;
  while (true) {
    index = this.indexOf(element);
    if (index === -1) {
      break;
    }
    this.removeAt(index);
  }
  return this;
};

Array.prototype.removeMatch = function(predicate) {
  var index;
  index = this.findIndex(predicate);
  assert(index > -1);
  return this.removeAt(index);
};

Array.prototype.removeAllMatch = function(predicate) {
  var index;
  while (true) {
    index = this.findIndex(predicate);
    if (index === -1) {
      break;
    }
    this.removeAt(index);
  }
  return this;
};

if (Number.EPSILON === void 0) {
  Number.EPSILON = 2.2204460492503130808472633361816e-16;
}

if (Number.isInteger === void 0) {
  Number.isInteger = function(x) {
    return typeof x === "number" && isFinite(x) && x > -9007199254740992 && x < 9007199254740992 && Math.floor(x) === x;
  };
}

if (String.prototype.startsWith === void 0) {
  String.prototype.startsWith = function(s) {
    return this.indexOf(s) === 0;
  };
}

if (String.prototype.endsWith === void 0) {
  String.prototype.endsWith = function(s) {
    return this.lastIndexOf(s) === this.length - s.length;
  };
}

if (String.prototype.contains === void 0) {
  String.prototype.contains = function(s) {
    return this.indexOf(s) !== -1;
  };
}

if (Array.from === void 0) {
  Array.from = function(arrayLike) {
    var m, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arrayLike.length; _i < _len; _i++) {
      m = arrayLike[_i];
      _results.push(m);
    }
    return _results;
  };
}

if (Array.prototype.find === void 0) {
  Array.prototype.find = function(predicate) {
    var found;
    assert(typeof predicate === "function");
    found = this.filter(predicate);
    if (!found.isEmpty()) {
      return found.at(0);
    } else {
      return void 0;
    }
  };
}

if (Array.prototype.findIndex === void 0) {
  Array.prototype.findIndex = function(predicate) {
    var element;
    element = this.find(predicate);
    if (element === void 0) {
      return -1;
    } else {
      return this.indexOf(element);
    }
  };
}

if (Math.sign === void 0) {
  Math.sign = function(x) {
    if (typeof x === "number") {
      if (x === 0) {
        return 0;
      } else if (x > 0) {
        return 1;
      } else if (x < 0) {
        return -1;
      } else {
        return NaN;
      }
    } else {
      return NaN;
    }
  };
}

$mate = {};

compose = function(functions) {
  if (arguments.length > 1) {
    functions = Array.from(arguments);
  }
  return function() {
    var args, m, _i, _len;
    args = arguments;
    for (_i = 0, _len = functions.length; _i < _len; _i++) {
      m = functions[_i];
      args = [m.apply(this, args)];
    }
    return args[0];
  };
};

fail = function(errorMessage) {
  throw new Error(errorMessage);
};

assert = function(condition, message) {
  if (!condition) {
    return fail(message);
  }
};

repeat = function(times, iterator) {
  var i, _i, _results;
  _results = [];
  for (i = _i = 0; 0 <= times ? _i < times : _i > times; i = 0 <= times ? ++_i : --_i) {
    _results.push(iterator());
  }
  return _results;
};

spread = function(value, count) {
  var i, _i, _results;
  _results = [];
  for (i = _i = 0; 0 <= count ? _i < count : _i > count; i = 0 <= count ? ++_i : --_i) {
    _results.push(value);
  }
  return _results;
};

setAdvancedInterval = function(callback, interval, startTime, triggersAtStart, timesOrEndTime, endCallback, isEndCallbackImmediate) {
  var count, isEnded, nextTime, r;
  if (startTime == null) {
    startTime = new Date();
  }
  if (triggersAtStart == null) {
    triggersAtStart = true;
  }
  if (isEndCallbackImmediate == null) {
    isEndCallbackImmediate = true;
  }
  if (interval < 100) {
    interval = 100;
  }
  isEnded = false;
  count = 0;
  nextTime = new Date(startTime - (-interval * (triggersAtStart ? 0 : 1)));
  if ((timesOrEndTime != null) && ((typeof timesOrEndTime === "number" && timesOrEndTime < 1) || (typeof timesOrEndTime === "object" && timesOrEndTime < nextTime))) {
    if (typeof endCallback === "function") {
      endCallback();
    }
    return null;
  } else {
    r = setInterval(function() {
      var idealTime, nowTime;
      if (new Date() >= nextTime) {
        if (isEnded) {
          clearAdvancedInterval(r);
          return typeof endCallback === "function" ? endCallback() : void 0;
        } else {
          count++;
          idealTime = nextTime;
          nowTime = new Date();
          nextTime = new Date(nextTime - (-interval));
          if (callback(idealTime, nowTime, count - 1) === false || ((timesOrEndTime != null) && ((typeof timesOrEndTime === "number" && count === timesOrEndTime) || (typeof timesOrEndTime === "object" && nextTime > timesOrEndTime)))) {
            isEnded = true;
            if (isEndCallbackImmediate) {
              clearAdvancedInterval(r);
              return typeof endCallback === "function" ? endCallback() : void 0;
            }
          }
        }
      }
    }, 30);
    return r;
  }
};

clearAdvancedInterval = function(x) {
  return clearInterval(x);
};

Object.getter = function(obj, prop, fun) {
  return Object.defineProperty(obj, prop, {
    get: fun,
    configurable: true
  });
};

Object.setter = function(obj, prop, fun) {
  return Object.defineProperty(obj, prop, {
    set: fun,
    configurable: true
  });
};

Object.clone = function(x) {
  var key, y, _i, _len, _ref;
  y = {};
  _ref = Object.keys(x);
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    key = _ref[_i];
    y[key] = x[key];
  }
  return y;
};

JSON.clone = function(x) {
  return JSON.parse(JSON.stringify(x));
};

Number.isFraction = function(x) {
  return typeof x === "number" && isFinite(x) && Math.floor(x) !== x;
};

Number.parseFloatExt = function(s) {
  return parseFloat(s) * (s.endsWith("%") ? 0.01 : 1);
};

String.prototype.matches = function(regex) {
  var adjustedRegex, match, result;
  adjustedRegex = new RegExp(regex.source, "g");
  result = [];
  while (true) {
    match = adjustedRegex.exec(this);
    if (match != null) {
      result.push(match);
    } else {
      break;
    }
  }
  return result;
};

String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.substr(1);
};

Date.prototype.add = function(x) {
  return new Date(this - (-x));
};

Date.prototype.subtract = function(x) {
  if (typeof x === "number") {
    return new Date(this - x);
  } else {
    return this - x;
  }
};

Date.prototype.equals = function(x) {
  return (x <= this && this <= x);
};

console.logt = function() {
  return console.log.apply(null, [new Date().toISOString()].concat(Array.from(arguments)));
};

ObjectWithEvents = (function() {
  function ObjectWithEvents() {
    this._eventList = {};
  }

  ObjectWithEvents.prototype.on = function(eventName, listener) {
    var _base;
    if ((_base = this._eventList)[eventName] == null) {
      _base[eventName] = [];
    }
    if (__indexOf.call(this._eventList[eventName], listener) < 0) {
      this._eventList[eventName].push(listener);
    }
    return this;
  };

  ObjectWithEvents.prototype.off = function(eventName, listener) {
    this._eventList[eventName].removeAll(listener);
    return this;
  };

  ObjectWithEvents.prototype.trigger = function(eventName, arg) {
    var m, _base, _i, _len, _ref;
    if ((_base = this._eventList)[eventName] == null) {
      _base[eventName] = [];
    }
    _ref = this._eventList[eventName];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      m = _ref[_i];
      m(arg);
    }
    return void 0;
  };

  ObjectWithEvents.prototype.listeners = function(eventName) {
    return this._eventList[eventName];
  };

  return ObjectWithEvents;

})();

Math.nearlyEquals = function(a, b) {
  var threshold, _ref;
  threshold = 1 + 1 / 65536;
  return (1 / threshold < (_ref = a / b) && _ref < threshold);
};

Math.nearlyGreaterThan = function(a, b) {
  return a > b || Math.nearlyEquals(a, b);
};

Math.nearlyLessThan = function(a, b) {
  return a < b || Math.nearlyEquals(a, b);
};

Math.radiansToDegrees = function(radians) {
  return radians / Math.PI * 180;
};

Math.degreesToRadians = function(degrees) {
  return degrees / 180 * Math.PI;
};

Math.principalRadians = function(radians) {
  var t;
  t = radians % (2 * Math.PI);
  if (t <= -Math.PI) {
    return t + 2 * Math.PI;
  } else if (t > Math.PI) {
    return t - 2 * Math.PI;
  } else {
    return t;
  }
};

Math.principalDegrees = function(degrees) {
  var t;
  t = degrees % 360;
  if (t <= -180) {
    return t + 360;
  } else if (t > 180) {
    return t - 360;
  } else {
    return t;
  }
};

Math.randomNumber = function(m, n) {
  if (m < n) {
    return m + Math.random() * (n - m);
  } else {
    return fail();
  }
};

Math.randomInt = function(m, n) {
  var max, min;
  min = n === void 0 ? 0 : m;
  max = n === void 0 ? m : n;
  return Math.floor(Math.randomNumber(min, max));
};

Number.prototype.nearlyEquals = function(x) {
  return Math.nearlyEquals(this, x);
};

Number.prototype.nearlyGreaterThan = function(x) {
  return Math.nearlyGreaterThan(this, x);
};

Number.prototype.nearlyLessThan = function(x) {
  return Math.nearlyLessThan(this, x);
};

Point = (function() {
  function Point(x, y) {
    this.x = x;
    this.y = y;
  }

  Point.from = function(value) {
    if (typeof value === "number") {
      return new Point(value, 0);
    } else if (value instanceof Point) {
      return value.clone();
    } else if (typeof value === "string") {
      return Point.fromString(value);
    } else if (Array.isArray(value)) {
      return Point.fromArray(value);
    } else {
      return fail();
    }
  };

  Point.fromArray = function(array) {
    return new Point(array[0], array[1]);
  };

  Point.fromString = function(s) {
    var adjustedString, complexMatch, imaginary, normalMatch, real, _ref, _ref1;
    adjustedString = s.replace(/[\x20()]/g, "");
    normalMatch = adjustedString.match(/^([^,]*),(.*)$/);
    if (normalMatch != null) {
      return new Point(Number.parseFloatExt(normalMatch[1]), Number.parseFloatExt(normalMatch[2]));
    } else {
      complexMatch = adjustedString.match(/^([+-]?[0-9]*\.?[0-9]*(?:[Ee][+-]?[0-9]+)?(?![i0-9Ee.]))?(?:([+-]?[0-9]*\.?[0-9]*(?:[Ee][+-]?[0-9]+)?)i)?$/);
      if (complexMatch != null) {
        real = (_ref = complexMatch[1]) != null ? _ref : "0";
        imaginary = (_ref1 = complexMatch[2]) != null ? _ref1 : "0";
        if (real === "") {
          real = "1";
        }
        if (imaginary === "") {
          imaginary = "1";
        }
        if (real === "+") {
          real = "1";
        }
        if (imaginary === "+") {
          imaginary = "1";
        }
        if (real === "-") {
          real = "-1";
        }
        if (imaginary === "-") {
          imaginary = "-1";
        }
        return new Point(parseFloat(real), parseFloat(imaginary));
      } else {
        return fail();
      }
    }
  };

  Point.fromPolar = function(r, angle) {
    return new Point(r * Math.cos(angle), r * Math.sin(angle));
  };

  Point.fromPolarInDegrees = function(r, angle) {
    switch (Math.principalDegrees(angle)) {
      case 0:
        return new Point(r, 0);
      case 90:
        return new Point(0, r);
      case -90:
        return new Point(0, -r);
      case 180:
        return new Point(-r, 0);
      default:
        return Point.fromPolar(r, Math.degreesToRadians(angle));
    }
  };

  Point.prototype.real = function() {
    return this.x;
  };

  Point.prototype.imaginary = function() {
    return this.y;
  };

  Point.prototype.toString = function() {
    return "(" + this.x + "," + this.y + ")";
  };

  Point.prototype.toComplexString = function() {
    var sign;
    sign = this.y >= 0 ? "+" : "-";
    return "" + this.x + sign + (Math.abs(this.y)) + "i";
  };

  Point.prototype.clone = function() {
    return new Point(this.x, this.y);
  };

  Point.prototype.equals = function(p) {
    return cmath.equals(this, p);
  };

  Point.prototype.nearlyEquals = function(p) {
    return cmath.nearlyEquals(this, p);
  };

  Point.prototype.opposite = function() {
    return cmath.opposite(this);
  };

  Point.prototype.reciprocal = function() {
    return cmath.reciprocal(this);
  };

  Point.prototype.conjugate = function() {
    return cmath.conjugate(this);
  };

  Point.prototype.abs = function() {
    return cmath.abs(this);
  };

  Point.prototype.add = function(p) {
    return cmath.add(this, p);
  };

  Point.prototype.subtract = function(p) {
    return cmath.subtract(this, p);
  };

  Point.prototype.multiply = function(p) {
    return cmath.multiply(this, p);
  };

  Point.prototype.divide = function(p) {
    return cmath.divide(this, p);
  };

  Point.prototype.distance = function(p) {
    return cmath.distance(this, p);
  };

  Point.prototype.dotProduct = function(p) {
    p = Point.from(p);
    return this.x * p.x + this.y * p.y;
  };

  Point.prototype.crossProduct = function(p) {
    p = Point.from(p);
    return this.x * p.y - this.y * p.x;
  };

  Point.prototype.isOppositeTo = function(p) {
    return this.opposite().equals(p);
  };

  Point.prototype.phase = function() {
    return cmath.phase(this);
  };

  Point.prototype.phaseTo = function(p) {
    p = Point.from(p);
    return Math.principalRadians(p.phase() - this.phase());
  };

  Point.prototype.phaseInDegrees = function() {
    return cmath.phaseInDegrees(this);
  };

  Point.prototype.phaseInDegreesTo = function(p) {
    p = Point.from(p);
    return Math.principalDegrees(p.phaseInDegrees() - this.phaseInDegrees());
  };

  Point.prototype.scale = function(size) {
    size = Point.from(size);
    return new Point(this.x * size.x, this.y * size.y);
  };

  Point.prototype.rotate = function(angle) {
    return this.multiply(Point.fromPolar(1, angle));
  };

  Point.prototype.rotateDegrees = function(angle) {
    return this.multiply(Point.fromPolarInDegrees(1, angle));
  };

  return Point;

})();

cmath = {
  equals: function(a, b) {
    a = Point.from(a);
    b = Point.from(b);
    return a.x === b.x && a.y === b.y;
  },
  nearlyEquals: function(a, b) {
    a = Point.from(a);
    b = Point.from(b);
    return a.x.nearlyEquals(b.x) && a.y.nearlyEquals(b.y);
  },
  opposite: function(p) {
    p = Point.from(p);
    return new Point(-p.x, -p.y);
  },
  reciprocal: function(p) {
    var n;
    p = Point.from(p);
    n = p.x * p.x + p.y * p.y;
    return new Point(p.x / n, -p.y / n);
  },
  conjugate: function(p) {
    p = Point.from(p);
    return new Point(p.x, -p.y);
  },
  abs: function(p) {
    p = Point.from(p);
    if (p.x === 0) {
      return Math.abs(p.y);
    } else if (p.y === 0) {
      return Math.abs(p.x);
    } else {
      return Math.sqrt(p.x * p.x + p.y * p.y);
    }
  },
  phase: function(p) {
    p = Point.from(p);
    return Math.atan2(p.y, p.x);
  },
  phaseInDegrees: function(p) {
    var d;
    p = Point.from(p);
    if (p.x === 0 && p.y === 0) {
      return 0;
    } else if (p.x === 0 && p.y > 0) {
      return 90;
    } else if (p.x === 0 && p.y < 0) {
      return -90;
    } else if (p.x > 0 && p.y === 0) {
      return 0;
    } else if (p.x < 0 && p.y === 0) {
      return 180;
    } else {
      d = Math.radiansToDegrees(cmath.phase(p));
      if (d <= -180) {
        return 180;
      } else {
        return d;
      }
    }
  },
  add: function(a, b) {
    a = Point.from(a);
    b = Point.from(b);
    return new Point(a.x + b.x, a.y + b.y);
  },
  subtract: function(a, b) {
    return cmath.add(a, cmath.opposite(b));
  },
  multiply: function(a, b) {
    a = Point.from(a);
    b = Point.from(b);
    return new Point(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
  },
  divide: function(a, b) {
    return cmath.multiply(a, cmath.reciprocal(b));
  },
  distance: function(a, b) {
    return cmath.abs(cmath.subtract(a, b));
  },
  exp: function(p) {
    p = Point.from(p);
    return Point.fromPolar(Math.exp(p.x), p.y);
  },
  log: function(p) {
    return new Point(Math.log(cmath.abs(p)), cmath.phase(p));
  },
  pow: function(a, b) {
    return cmath.exp(cmath.multiply(cmath.log(a), b));
  },
  sqrt: function(p) {
    var r;
    p = Point.from(p);
    r = cmath.abs(p);
    return new Point(Math.sqrt((r + p.x) / 2), Math.sign(p.y) * Math.sqrt((r - p.x) / 2));
  },
  cos: function(p) {
    return cmath.divide(cmath.add(cmath.exp(cmath.multiply(p, new Point(0, 1))), cmath.exp(cmath.multiply(cmath.opposite(p), new Point(0, 1)))), 2);
  },
  sin: function(p) {
    return cmath.divide(cmath.subtract(cmath.exp(cmath.multiply(p, new Point(0, 1))), cmath.exp(cmath.multiply(cmath.opposite(p), new Point(0, 1)))), new Point(0, 2));
  },
  tan: function(p) {
    return cmath.divide(cmath.sin(p), cmath.cos(p));
  },
  acos: function(p) {
    return cmath.opposite(cmath.multiply(cmath.log(cmath.add(p, cmath.multiply(cmath.sqrt(cmath.add(cmath.opposite(cmath.multiply(p, p)), 1)), new Point(0, 1)))), new Point(0, 1)));
  },
  asin: function(p) {
    return cmath.opposite(cmath.multiply(cmath.log(cmath.add(cmath.multiply(p, new Point(0, 1)), cmath.sqrt(cmath.add(cmath.opposite(cmath.multiply(p, p)), 1)))), new Point(0, 1)));
  },
  atan: function(p) {
    return cmath.multiply(cmath.subtract(cmath.log(cmath.subtract(1, cmath.multiply(p, new Point(0, 1)))), cmath.log(cmath.add(1, cmath.multiply(p, new Point(0, 1))))), new Point(0, 0.5));
  }
};

$mate.test = {
  add: function(name, testFunctions, delay, timeout) {
    var _this = this;
    if (typeof name !== "string") {
      timeout = delay;
      delay = testFunctions;
      testFunctions = name;
      name = "Test_" + this._defaultNameCounter;
      this._defaultNameCounter++;
    }
    if (typeof testFunctions === "function") {
      testFunctions = [testFunctions];
    }
    if (delay == null) {
      delay = 0;
    }
    if (timeout == null) {
      timeout = 86400000;
    }
    this._list[name] = {
      contexts: testFunctions.map(function(m) {
        return {
          name: name,
          fun: m,
          state: null
        };
      }),
      delay: delay,
      timeout: timeout
    };
    return this;
  },
  run: function() {
    var startTime, timer,
      _this = this;
    startTime = new Date();
    Object.keys(this._list).forEach(function(name) {
      var item;
      item = _this._list[name];
      return item.contexts.forEach(function(context) {
        return setTimeout(function() {
          var domain, isAsync, match;
          match = context.fun.toString().match(/function *\(([^)]*)\)/);
          isAsync = (match != null) && match[1].trim().length > 0;
          domain = require("domain").create();
          domain.on("error", function(error) {
            context.state = false;
            return context.errorMessage = error.stack;
          });
          return domain.run(function() {
            if (isAsync) {
              return context.fun(context);
            } else {
              if (context.fun() !== false) {
                return context.state = true;
              } else {
                return context.state = false;
              }
            }
          });
        }, item.delay);
      });
    });
    console.log();
    timer = setAdvancedInterval(function(time) {
      var all, failure, pending, success;
      all = [];
      Object.keys(_this._list).forEach(function(name) {
        var item;
        item = _this._list[name];
        return item.contexts.forEach(function(m) {
          if (m.result == null) {
            if (time.subtract(startTime) > _this.timeout || time.subtract(startTime.add(item.delay)) > item.timeout) {
              m.result = false;
            } else if (m.state != null) {
              m.result = m.state;
            }
          }
          return all.push(m);
        });
      });
      success = all.filter(function(m) {
        return m.result === true;
      });
      failure = all.filter(function(m) {
        return m.result === false;
      });
      pending = all.filter(function(m) {
        return m.result !== true && m.result !== false;
      });
      console.logt(("Success: " + success.length + ", Failure: " + failure.length + ", ") + ("Pending: " + pending.length));
      if (pending.length === 0) {
        clearAdvancedInterval(timer);
        failure.forEach(function(m) {
          console.log("\nFailure \"" + m.name + "\":");
          console.log(m.fun.toString());
          if (m.errorMessage != null) {
            return console.log(m.errorMessage);
          }
        });
        console.log("\n" + (failure.length === 0 ? "Completed. All succeeded." : "Completed. " + failure.length + " failures.") + "\n");
        return process.exit();
      }
    }, 1000);
    return this;
  },
  timeout: 86400000,
  _list: {},
  _defaultNameCounter: 0
};

if ((typeof exports !== "undefined" && exports !== null) && ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null)) {
  global.$mate = $mate;
  global.compose = compose;
  global.fail = fail;
  global.assert = assert;
  global.repeat = repeat;
  global.spread = spread;
  global.setAdvancedInterval = setAdvancedInterval;
  global.clearAdvancedInterval = clearAdvancedInterval;
  global.cmath = cmath;
  global.Point = Point;
  global.ObjectWithEvents = ObjectWithEvents;
}
$mate.nodePackageInfo =
{
    "name": "mate",
    "version": "0.5.0",
    "description": "A library that extends native JavaScript / CoffeeScript.",
    "keywords": ["library", "app", "javascript", "coffeescript", "js"],
    "author": "Zhenzhen Zhan <zhanzhenzhen@hotmail.com>",
    "homepage": "https://github.com/zhanzhenzhen/mate",
    "licenses": [{
        "type": "MIT",
        "url": "https://github.com/zhanzhenzhen/mate/blob/master/LICENSE.txt"
    }],
    "repository": {
        "type": "git",
        "url": "https://github.com/zhanzhenzhen/mate.git"
    },
    "main": "mate"
}
;
