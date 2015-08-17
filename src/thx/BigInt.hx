package thx;

abstract BigInt(Array<Int>) {
  public static var zero(default, null) = new BigInt([0]);

  var sign(get, never) : Int;
  var chunks(get, never) : Array<Int>;
  var length(get, never) : Int;

  var isNegative(get, never) : Bool;
  var isZero(get, never) : Bool;

  @:from public static function fromInt(value : Int)
    return zero + value;

  inline function new(arr : Array<Int>)
    this = arr;

  @:op(A+B) function addInt(that : Int) : BigInt {
//    if(that < 0)
//      return sub(-that);
    var arr = this.copy(),
        c = 0, b;
    //trace(arr);
    arr[0] += that;
    for(i in 0...arr.length) {
      c += arr[i];
      b = 0;
      if(c < 0) {
        b =- (c >> bpe);
        c += b * radix;
      }
      arr[i] = c & mask;
      c = (c >> bpe) - b;
      if(c == 0) break;
    }
    while(c != 0) {
      if(c < 0) {
        b =- (c >> bpe);
        c += b * radix;
      }
      arr.push(c & mask);
      c = (c >> bpe) - b;
    }
    return new BigInt(arr);
  }
/*
  @:op(A-B) function sub(that : Int) : BigInt {
    if(that < 0)
      return add(-that);
    var arr = this.copy(),
        c = 0, b;
    //trace(arr);
    arr[0] += that;
    for(i in 0...arr.length) {
      c += arr[i];
      b = 0;
      if(c < 0) {
        b =- (c >> bpe);
        c += b * radix;
      }
      arr[i] = c & mask;
      c = (c >> bpe) - b;
      if(c == 0) break;
    }
    while(c != 0) {
      if(c < 0) {
        b =- (c >> bpe);
        c += b * radix;
      }
      arr.push(c & mask);
      c = (c >> bpe) - b;
    }
    return new BigInt(arr);
  }
*/
  inline function get_sign()
    return this[0];

  inline function get_chunks()
    return this.slice(1);

  inline function get_length()
    return this.length - 1;

  @:to public function toString() {
    var s = "",
        v = new BigInt(this),
        p;
    //trace(v.toArray());
    while(!v.isZero) {
      //trace(v.toArray());
      p = v.intDivision(10);
      //trace(p.reminder);
      v = p.value;
      s = digits.substring(p.reminder, p.reminder + 1) + s;
    }
    if(s.length == 0)
      s = "0";
    return s;
  }

  function intDivision(that : Int) {
    var arr = this.copy(),
        i = arr.length - 1,
        r = 0, s;
    while(i >= 0) {
      s = r * radix + arr[i];
      arr[i] = Math.floor(s / that);
      r = s % that;
      i--;
    }
    return {
      value : new BigInt(arr),
      reminder : r
    };
  }

  inline function toArray()
    return this;

  inline function self() : BigInt
    return new BigInt(this);

  function get_isNegative()
    return ((this[this.length-1] >> (bpe - 1)) & 1) == 1;

  function get_isZero() {
    for(v in this)
      if(v != 0) return false;
    return true;
  }

  inline static function apply(arr : Array<Int>, len : Int, n : Int) {
    for(i in 0...len) {
      arr[i] = n & mask;
      n >>= bpe;
    }
  }

  static var bpe : Int;
  static var mask : Int;
  static var radix : Int;
  static var digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_=!@#$%^&*()[]{}|;:,.<>/?`~ \\\'\"+-';

  static function __init__() {
    bpe = 0;
    while((1<<(bpe+1)) > (1<<bpe))
      bpe++;
    bpe >>= 1;
    mask = (1 << bpe) - 1;
    radix = mask + 1;

    //trace('bpe: $bpe');
    //trace('mask: $mask');
    //trace('radix: $radix');
  }
}
