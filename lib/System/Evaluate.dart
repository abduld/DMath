
part of System;

class Context {
  static final List<Map<String, Expr>> _symbolTable = [<String, Expr>{}];
  
  const Context();
  
  Expr addSymbol(String name, Expr e) {
    _symbolTable[level][name] = e;
    return e;
  }
  
  Expr addFunction(String name, Expr e) {
    if (containsValue(name) && (e as Evaluatable).attributes.contains(eProtected)) {
      throw new ArgumentError("Assigning to protected symbol.");
    }
    _symbolTable[level][name] = e;
    return e;
  }

  Expr getValue(key0) {
    var val;
    String key;
    if (key0 is Expr) {
      key = key0.toString();
    } else if (key0 is String) {
      key = key0;
    } else {
      throw new TypeError();
    }
    for (val in _symbolTable.reversed) {
      print(val);
      if (val.containsKey(key)) {
        return val[key];
      }
    }
    return eNull;
  }
  
  bool containsValue(key) {
    if (key is Expr) {
      key = key.toString();
    }
    return _symbolTable.reversed.any((e) => e.containsKey(key));
  }
  
  void setValue(Expr lhs, Expr rhs) {
    String key = lhs.toString();
    print(level);
    _symbolTable[level][key] = rhs;
  }
  
  Expr evaluate(Expr e) {
    if (e is Evaluatable) {
      return e;
    } else if (e is ExprNormal) {
      return e;
    } else if (e.e is ExprSymbol) {
      if (containsValue(e.value)) {
        return getValue(e.toString());
      } else {
        return e;
      }
    } else if (e.e is ExprAtom) {
      return e;
    } else if (e.e is ExprNormal) {
      Expr hd = evaluate(e.head);
      List<Expr> bd = new List<Expr>();
      for (Expr i in e.e) {
        bd.add(evaluate(i));
      }
      return new Expr.normal(hd, new Expr(bd));
    } else {
      throw new UnimplementedError(e.toString());
    }
  }
  
  Expr evalWith(Expr e, Expr lhs, Expr rhs) {
    Expr res;
    pushContext();
    eEval(this, eSet, [lhs, rhs]);
    res = evaluate(e);
    popContext();
    return res;
  }
  
  pushContext() => _symbolTable.add(<String, Expr>{});
  popContext()  => _symbolTable.removeLast();
  
  int get level => _symbolTable.length - 1;
}

final Context eContext = new Context();

addSymbol(Expr e) => eContext.addSymbol(e.value, e);
newSymbol(String s) => addSymbol(new Expr.symbol(s));
newFunction(Evaluatable e) => eContext.addFunction(e.name.toString(), e);
