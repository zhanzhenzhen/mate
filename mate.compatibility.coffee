# This is in ECMAScript 6. Only Firefox natively supports this.
if String::startsWith == undefined
    String::startsWith = (s) -> @indexOf(s) == 0
# This is in ECMAScript 6. Only Firefox natively supports this.
if String::endsWith == undefined
    String::endsWith = (s) -> @lastIndexOf(s) == @length - s.length
# This is in ECMAScript 6. Only Firefox natively supports this.
if String::contains == undefined
    String::contains = (s) -> @indexOf(s) != -1
# This is in ECMAScript 6. No browser natively supports this.
if Array.from == undefined
    Array.from = (arrayLike) -> m for m in arrayLike
