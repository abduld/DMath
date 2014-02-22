
library DMath;

import "System/System.dart";

void main() {
  
  /*
  Expr e1 = new Expr(2);
  Expr e2 = new Expr(1);
  //Attributes a = new Attributes();
  
  print(e1 + e2);
  
  IntegerQ ee = new IntegerQ();
  print(ee.evaluate(eContext, e1));
  

  Attributes ea = new Attributes();
  print(ea.evaluate(eContext, ee));
  
  Expr eTwo = new Expr(2);
  Expr eX = eOne;
  
  Expr s = new Expr("s");
  Expr t = s.evaluate(eContext, eOne);
  print(t.fullForm());
  
  Expr sym = new Expr.symbol("foo");
  eEval(eContext, eSet, [sym, eOne]);
  print(eContext.getValue(sym));
  
  print(eOne);
  Expr x1 = eEval(eContext, eSin, eOne);
  x1 = eEval(eContext, ePower, [x1, eTwo]);
  Expr x2 = eEval(eContext, eCos, eOne);
  x2 = eEval(eContext, ePower, [x2, eTwo]);
  Expr x3 = eEval(eContext, ePlus, [x1, x2]);
  
  Expr x4 = new Expr.symbol("y");
  eEval(eContext, eSet, [x4, eOne]);
  
  print(eEval(eContext, x4));
  
  */
  Expr x = new Expr.symbol("x");
  Expr e = eEval(eContext, eSin, [x]);
  eEval(eContext, eSet, [x, eOne]);
  Expr v = eEval(eContext, e);
  print(v);
  
  Expr plt = eEval(eContext, ePlot, new Expr([e, new Expr([x, new Expr(0), new Expr(1)])]));
  
  print(plt);
  
  //print(a);
  
  print("Hello, World!");
}
