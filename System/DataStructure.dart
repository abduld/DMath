
part of System;

class HalfEdgeMesh {
  
}

class Point {
  num x, y;
  Point(this.x, this.y);
  Point.zero() : x = 0, y = 0;
/*
  svg.Point toSVG() {
    svg.Point pt;
    pt.x = x;
    pt.y = y;
    return pt;
  }
*/
  Point.fromExpr(Expr x, Expr y) : this.x = x.toDouble(), this.y = y.toDouble();
  operator +(Point other) => new Point(x + other.x, y + other.y);
  operator -(Point other) => new Point(x - other.x, y - other.y);
  
  Expr toExpr() => new Expr([new Expr(x), new Expr(y)]);
}