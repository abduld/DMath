
part of System;


class Evaluatable extends Expr {
  Expr name = null;
  Expr get head => this;
  Expr get attributes => eEmptyList;
  Evaluatable([e]) : super(e);
  Expr evaluate(Context ctx, Expr v) {
    Expr res;
    if (v is! Evaluatable && v.length == 0 && attributes.contains(eOneIdentity)) {
      return eOne;
    } else {
      if (attributes.contains(eFlat)) {
        v = v.flatten();
      }
      if (attributes.contains(eOrderless)) {
        v = v.sort();
      }
      res = evaluate0(ctx, v);
      return res;
    }
  }
  Expr evaluate0(Context ctx, Expr v) => v;
  Expr IFAIL(Expr e) => new Expr.normal(this, e);
}



final Expr eEmptyList = new Expr([]);
final Expr eZero = new Expr(0);
final Expr eOne = new Expr(1);
final Expr eTwo = new Expr(2);
final Expr eTrue = newSymbol("True");
final Expr eFalse = newSymbol("False");
final Expr eNull = newSymbol("Null");
final Expr eHold = newSymbol("Hold");
final Expr eHoldFirst = newSymbol("HoldFirst");
final Expr eHoldAll = newSymbol("HoldAll");
final Expr eListable = newSymbol("Listable");
final Expr eSequenceHold = newSymbol("SequenceHold");
final Expr eProtected = newSymbol("Protected");
final Expr eNumericFunction = newSymbol("NumericFunction");
final Expr eFlat = newSymbol("Flat");
final Expr eOneIdentity = newSymbol("OneIdentity");
final Expr eOrderless = newSymbol("Orderless");


class TrueQ extends Evaluatable {
  final Expr name = new Expr.symbol("TrueQ");
  final Expr attributes = new Expr([eProtected]);
  Expr evaluate0(Context ctx, Expr e) => e.trueQ || e == eTrue ? eTrue : eFalse;
}


class IntegerQ extends Evaluatable {
  final Expr name = new Expr.symbol("IntegerQ");
  final Expr attributes = new Expr([eProtected]);
  Expr evaluate0(Context ctx, Expr e) => e.integerQ ? eTrue : eFalse;
}


class Attributes extends Evaluatable {
  final Expr name = new Expr.symbol("Attributes");
  final Expr attributes = new Expr([eHoldAll, eListable, eProtected]);
  Expr evaluate0(Context ctx, Expr e) => (e is! Evaluatable) ? eEmptyList : (e as Evaluatable).attributes;
}

class Sin extends Evaluatable {
  final Expr name = new Expr.symbol("Sin");
  final Expr attributes = new Expr([eListable, eNumericFunction, eProtected]);
  Expr evaluate0(Context ctx, Expr e) {
    if (e.numericQ) {
      return new Expr(sin(e.toDouble()));      
    } else {
      print(eSin);
      Expr res = new Expr.normal(eSin, e);
      return res;
    }
  }
}

class Cos extends Evaluatable {
  final Expr name = new Expr.symbol("Cos");
  final Expr attributes = new Expr([eListable, eNumericFunction, eProtected]);
  Expr evaluate0(Context ctx, Expr e) {
    if (e.numericQ) {
      return new Expr(cos(e.toDouble()));      
    } else {
      return IFAIL(e);
    }
  }
}

class Power extends Evaluatable {
  final Expr _head = new Expr.symbol("Power");
  final Expr attributes = new Expr([eListable, eNumericFunction, eProtected]);
  Expr evaluate0(Context ctx, Expr e) {
    Expr res = e[0];
    for (int ii = 1; ii < e[1].toInt(); ii++) {
      res *= e[0];
    }
    return res;
  }
}

class Plus extends Evaluatable {
  final Expr name = new Expr.symbol("Plus");
  final Expr attributes = new Expr([eFlat, eListable, eNumericFunction, eOneIdentity, eOrderless, eProtected]);
  Expr evaluate0(Context ctx, Expr e) {
    Expr res = e[0];
    for (int ii = 1; ii < e.length; ii++) {
      res += e[ii];
    }
    return res;
  }
}


class Subtract extends Evaluatable {
  final Expr name = new Expr.symbol("Subtract");
  final Expr attributes = new Expr([eListable, eNumericFunction, eProtected]);
  Expr evaluate0(Context ctx, Expr e) {
    Expr res = e[0];
    for (int ii = 1; ii < e.length; ii++) {
      res -= e[ii];
    }
    return res;
  }
}


final TrueQ eTrueQ = newFunction(new TrueQ());
final IntegerQ eIntegerQ = newFunction(new IntegerQ());
final Attributes eAttributes = newFunction(new Attributes());

final Cos eCos = newFunction(new Cos());
final Sin eSin = newFunction(new Sin());
final Power ePower = newFunction(new Power());
final Plus ePlus = newFunction(new Plus());


