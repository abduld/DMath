
part of System;

class ListPlot extends Evaluatable {
  List<Point> pts;
  ListPlot(this.pts);
  List<Point> draw() => this.pts;
  /*
  svg.PointList toSVG() {
    svg.PointList res;
    for (Point pt in pts) {
      res.appendItem(pt.toSVG());
    }
    return res;
  }
  */
}

const double DEGREE_5 = 5*PI/180;
const int MAX_RECURSION = 10;
double deriv(Point a, Point b) => (b.y - a.y) / (b.x - a.x);
double angle(Point a, Point b) => atan(deriv(a, b));

class Plot extends Evaluatable {
  final Expr _head = new Expr.symbol("Plot");
  Expr evaluate0(Context ctx, Expr e) {
    return makePlot(ctx, e[0], e[1][1], e[1][2], e[1][3]);
  }
  Expr makePlot(Context ctx, Expr e, Expr iterVar, Expr start, Expr end, [Expr nSamples = null]) {
    List<Point> pts;
    Point nowPt, prevPt;
    Expr nowE, prevE;
    Map<double, Expr> ys = <double, Expr>{};
    if (nSamples == null) {
      nSamples = new Expr(50);  
    }
    var step = (end - start) / nSamples;
    
    
    ctx.pushContext();
    
    Expr evalWith(iterVal, ii) {
      if (ys.containsKey(ii)) {
        return ys[ii]; 
      } else {
        Expr n = ctx.evalWith(e, iterVar, ii);
        ys[ii] = n;
        return n;
      }
    }

    addPoints(num start, num end, num step, [int recursion = 0]) {
      prevE = ctx.evalWith(e, iterVar, new Expr(start));
      prevPt = Point.fromExpr(new Expr(start), prevE);
      for (int ii = start + step; ii < end; ii += step) {
        nowE = evalWith(iterVar, ii);
        nowPt = Point.fromExpr(new Expr(ii), nowE);
        if (recursion < MAX_RECURSION && angle(nowPt, prevPt) > DEGREE_5) {
          addPoints(ii - step, ii, step / 2);
        }
        prevE = nowE;
        prevPt = nowPt;
      }
    }
    
    addPoints(start.toInteger(), end.toInteger(), step.toInt());
    
    ctx.popContext();
    
    Expr res = new Expr(pts.map((pt) => pt.toExpr()));
    
    return res;
  }
  List<Point> draw() {
    // evaluate;
    return null;
  }
  /*
  svg.PointList toSVG() {
    ListPlot plt = new ListPlot(pts);
    return plt.toSVG();
  }
  */
}

final Plot ePlot = newFunction(new Plot());
