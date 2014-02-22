
part of System;

final Expr eList = newSymbol("List");

class ExprList extends ExprNormal {
  get head => eList;
  ExprList([val]) : super(val);
  get listQ => true;
  ExprList flatten() {
    List<Expr> es = new List<Expr>();
    for (Expr e in value) {
      if (e.listQ) {
        es.addAll(e.flatten().e as ExprList);
      } else {
        es.add(e);
      }
    }
    return new ExprList(es);
  }
}

ExprList makeRange(Expr arg1, [Expr arg2 = null, Expr arg3 = null]) {
  ExprList e;
  Expr start, end, step;
  if (arg1 is Iterable) {
    arg3 = arg1.length == 3 ? arg1[2] : null;
    arg2 = arg1.length == 2 ? arg1[1] : null;
    arg1 = arg1[0];
  }
  
  if (arg3 != null) {
    if (arg3 == 0) {
      throw new ArgumentError("Step cannot not be 0");
    } else {
      step = arg3;
    }
    start = arg1;
    end = arg2;
  } else {
    step = eOne;
    if (arg2 == null) {
      start = eOne;
    } else {
      start = arg1;
      end = arg2;
    }
  }
  for (var ii = start.toInteger(); ii < end.toInteger(); ii += step.toInteger()) {
    e.add(new Expr(ii));
  }
  return e;
}

final Range eRange = newFunction(new Range());

class Range extends Evaluatable {
  final Expr attributes = new Expr([eHoldAll, eProtected]);
  Expr evaluate0(Context ctx, Expr e) {
    return new Expr(makeRange(e));
  }
}

final Table eTable = newFunction(new Table());

class Table extends Evaluatable {
  final Expr attributes = new Expr([eHoldAll, eProtected]);
  Expr evaluate0(Context ctx, Expr e) {
    ExprList res;
    ctx.pushContext();
    Expr toEval = e[1];
    ExprList range = Function.apply(makeRange, (e[2] as List<Expr>).sublist(1));
    for (var iter in range) {
      eEval(ctx, eSet, [e[2][0], iter]);
      res.add(toEval.evaluate(ctx, toEval));
    }
    ctx.popContext();
    return new Expr(res);
  }
}


final SetImediate eSet = newFunction(new SetImediate());

class SetImediate extends Evaluatable {
  final Expr attributes = new Expr([eHoldFirst, eProtected, eSequenceHold]);
  final name = new Expr.symbol("Set");
  Expr evaluate0(Context ctx, Expr e) {
    Expr lhs = e[0];
    Expr rhs = e[1];
    if (rhs is Evaluatable) {
      rhs = eEval(ctx, rhs);
    }
    ctx.setValue(lhs, rhs);
    return rhs;
  }
}

Expr eEval(Context ctx, Expr hd, [args]) {
  hd = ctx.evaluate(hd);
  if (hd is Evaluatable) {
    List params = [ctx];
    params.add(new Expr(args));
    return Function.apply(hd.evaluate, params);
  } else if (ctx.containsValue(hd)) {
    return ctx.getValue(hd);
  } else {
    ExprNormal e = new ExprNormal(args);
    e.head = hd;
    return new Expr(e);
  }
}
