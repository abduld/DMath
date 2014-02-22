
part of System;


abstract class ExprBase implements Comparable {
  Expr _head;
  ExprBase();
  Expr get head => _head;
  get value => null;

  get atomQ => true;
  get numericQ => false;
  get normalQ => false;
  get integerQ => false;
  get numberQ => false;
  get machineNumberQ => false;
  get inexactNumberQ => false;
  get exactNumberQ => false;
  get trueQ => false;
  get listQ => false;
  get packedArrayQ => false;
  get booleanQ => false;
  
  int toInt() => throw new TypeError();
  double toDouble() => throw new TypeError();
  
  int get hashCode => value.hashCode;
  sameQ(other) => hashCode == other.hashCode;
  bool operator ==(other) => sameQ(other);
  
  String toString() => value.toString();
  String fullForm() {
    StringBuffer output = new StringBuffer("");
    if (head != head.head) {
      output.write(head);
      output.write("[");
    }
    if (value is Iterable) {
      output.writeAll(value.map((e) => e.fullForm()), ",");
    } else {
      output.write(value);
    }
    if (head != head.head) {
      output.write("]");
    }
    return output.toString();
  }
  int compareTo(Expr other) => -1;
  //accept(Visitor v);
}

final Expr eAtom = newSymbol("Atom");

abstract class ExprAtom extends ExprBase {
  get head => eAtom;
  ExprSymbol part(int ii) => ii == 0 ? new ExprSymbol(head) : throw new RangeError("index $ii out of range.");
}

final Expr eSymbol = newSymbol("Symbol");

class ExprSymbol extends ExprAtom {
  final String value;
  static Map<String, ExprSymbol> _cache;

  factory ExprSymbol(String value) {
    if (_cache == null) {
      _cache = {};
    }

    if (_cache.containsKey(value)) {
      return _cache[value];
    } else {
      final symbol = new ExprSymbol._internal(value);
      _cache[value] = symbol;
      return symbol;
    }
  }

  ExprSymbol._internal(this.value);

  get atomQ => false;
  get head => eSymbol;
  get symbolQ => true;
  get booleanQ => (value == "True" || value == "False");
  get trueQ => value == "True";
  String toString() => value;
}

final Expr eString = newSymbol("String");

class ExprString extends ExprAtom {
  final String value;
  ExprString(this.value);
  get head => eString;
  String toString() => '"$value"';
}

final Expr eNormal = newSymbol("Normal");

class ExprNormal extends ExprBase with IterableMixin<Expr> {
  List<Expr> value;

  set head(Expr val) => this._head = val; 
  
  ExprNormal([es = null]) {
    if (es == null) {
      value = new List<Expr>();
    } else if (es is List<Expr>) {
      value = es;
    } else if (es is Iterable) {
      for (var e in es) {
        value.add(new Expr(e));
      }
    } else if (es is Expr) {
      value = es.value;
    } else {
      value = new List<Expr>(es);
    }
  }
  
  Iterator<Expr> get iterator => value.iterator;
  
  Expr sort() {
    List<Expr> tmp = value;
    tmp.sort();
    return new Expr(tmp);
  }
  
  void add(Expr val) => value.add(val);
  
  //accept(Visitor v) => v.visitExprLiteral(this);
  bool operator ==(o) => o is ExprNormal && o.head == head && o.value == value;

  String toString() => fullForm();
  
  get length => value.length;
  get normalQ => true;
}

final Expr eNumeric = newSymbol("Numeric");

class ExprNumeric<T> extends ExprAtom {
  final T value;
  get head => eNumeric;
  ExprNumeric(this.value);

  get numericQ => true;
  get numberQ => true;

  int toInt() => value as T;
  double toDouble() => value as T;

  int compareTo(other) {
    if (other is Expr) {
      return value.compareTo(other.value);
    } else {
      return value.compareTo(other);
    }
  }
}


final Expr eReal = newSymbol("Real");

class ExprReal extends ExprNumeric<double> {
  get head => eReal;
  ExprReal(num value) : super(value);
  
  operator *(other) {
    if (other is ExprNumeric<num>) {
      num res = value * other.value;
      return new ExprReal(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator +(other) {
    if (other is ExprNumeric<num>) {
      num res = value + other.value;
      return new ExprReal(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator -(other) {
    if (other is ExprNumeric<num>) {
      num res = value - other.value;
      return new ExprReal(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator /(other) {
    if (other is ExprNumeric<num>) {
      num res = value / other.value;
      return new ExprReal(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator -() {
    return new ExprReal(-value);
  }

  int toInt() => value.toInt();
}

final Expr eInteger = newSymbol("Integer");

class ExprInteger extends ExprNumeric<int> {
  get head => eInteger;
  ExprInteger(int value) : super(value);

  operator *(other) {
    if (other is ExprNumeric<num>) {
      num res = value * other.value;
      return new ExprInteger(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator +(other) {
    if (other is ExprNumeric<num>) {
      num res = value + other.value;
      return new ExprInteger(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator -(other) {
    if (other is ExprNumeric<num>) {
      num res = value - other.value;
      return new ExprInteger(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator /(other) {
    if (other is ExprNumeric<num>) {
      num res = value / other.value;
      return new ExprInteger(res);
    } else {
      throw new UnimplementedError();
      return null;
    }
  }
  operator -() {
    return new ExprInteger(-value);
  }

  get integerQ => true;
  double toDouble() => value.toDouble();
}


class Expr implements Comparable {
  ExprBase e;
  Expr([value]) {
    if (value == null) {
      value = null;
    } else if (value is ExprBase) {
      this.e = value;
    } else if (value is Iterable) {
      this.e = new ExprList(value);
    } else if (value is int) {
      this.e = new ExprInteger(value);
    } else if (value is double) {
      this.e = new ExprReal(value);
    } else if (value is String) {
      this.e = new ExprString(value);
    } else if (value is Expr) {
      this.e = value.e;
    } else {
      throw new UnimplementedError();
    }
  }
  
  Expr.symbol(String name) : this.e = new ExprSymbol(name);
  Expr.normal(Expr hd, Expr val) {
    this.e = new ExprNormal(val);
    (this.e as ExprNormal).head = hd;
  }
  
  operator *(other) => new Expr(e.value * other.e.value);
  operator +(other) => new Expr(e.value + other.e.value);
  operator -(other) => new Expr(e.value - other.e.value);
  operator /(other) => new Expr(e.value / other.e.value);
  operator -() => new Expr(-e.value);
  
  Expr sort() {
    if (e.listQ) {
      return new Expr((e as ExprList).sort());
    } else {
      return new Expr(e);
    }
  }

  Expr flatten() {
    if (e.listQ) {
      return new Expr((e as ExprList).flatten());
    } else {
      return new Expr(e);
    }
  }
  
  operator [](int idx) {
    if (e.normalQ) {
      return e.value[idx];
    } else {
      throw new RangeError.value(idx);
      return null;
    }
  }
  
  get length {
    if (e.normalQ) {
      return e.value.length;
    } else {
      return 0;
    }
  }
  
  get head => e.head;
  get value => e.value;
  get atomQ => e.atomQ;
  get numericQ => e.numericQ;
  get normalQ => e.normalQ;
  get integerQ => e.integerQ;
  get numberQ => e.numberQ;
  get machineNumberQ => e.machineNumberQ;
  get inexactNumberQ => e.inexactNumberQ;
  get exactNumberQ => e.exactNumberQ;
  get trueQ => e.trueQ;
  get booleanQ => e.booleanQ;
  get listQ => e.listQ;

  int compareTo(Expr other) => e.compareTo(other.value);
  
  int toInt() => value.toInt();
  double toDouble() => value.toDouble();
  
  Expr evaluate(Context ctx, Expr e) => eEval(ctx, this, [e]);
  Expr evaluate0(Context ctx, Expr e) => evaluate(ctx, e);
  
  bool contains(Expr val) => normalQ && (e as ExprNormal).contains(val);
  
  String toString() => e.toString();
  String fullForm() => e.fullForm();
}

/*
class ExprSymbol extends Expr {
  final String value;
  
}

class ExprList extends Expr {
}

class ExprPackedArray extends Expr {
  final List<num> value;
}
*/




