import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart' show Color, HSVColor;

enum LightSource { topLeft, topRight, bottomLeft, bottomRight }

enum SurfaceShape { convex, concave }

Color mixColor(Color firstColor, Color secondColor, double amount) {
  return Color.lerp(firstColor, secondColor, amount);
}

HSVColor x(a, b, t) {
  assert(t != null);
  if (a == null && b == null) return null;
  if (a == null) return b._scaleAlpha(t);
  if (b == null) return a._scaleAlpha(1.0 - t);
  return HSVColor.fromAHSV(
    lerpDouble(a.alpha, b.alpha, t).clamp(0.0, 1.0),
    lerpDouble(a.hue, b.hue, t) % 360.0,
    lerpDouble(a.saturation, b.saturation, t).clamp(0.0, 1.0),
    lerpDouble(a.value, b.value, t).clamp(0.0, 1.0),
  );
}

int toIntByte(double x) {
  return x.toInt().clamp(0, 255);
}

Color fromHSVtoRGB(double h, double s, double v, {double a = 255}) {
  int ax = toIntByte(a);
  if (s == 0.0)
    return Color.fromARGB(ax, toIntByte(v), toIntByte(v), toIntByte(v));
  int i = (h * 6.0).toInt(); // Assume int truncates.
  double f = (h * 6.0) - i;
  int p = toIntByte(v * (1.0 - s));
  int q = toIntByte(v * (1.0 - s * f));
  int t = toIntByte(v * (1.0 - s * (1.0 - f)));
  int vx = toIntByte(v);

  i = i % 6;
  switch (i) {
    case 0:
      return Color.fromARGB(ax, vx, t, p);
      break;
    case 1:
      return Color.fromARGB(ax, q, vx, p);
      break;
    case 2:
      return Color.fromARGB(ax, p, vx, t);
      break;
    case 3:
      return Color.fromARGB(ax, p, q, vx);
      break;
    case 4:
      return Color.fromARGB(ax, t, p, vx);
      break;
    case 5:
      return Color.fromARGB(ax, vx, p, q);
      break;
    default:
      return Color.fromARGB(ax, vx, vx, vx);
  }
}
