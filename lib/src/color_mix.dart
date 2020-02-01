import 'package:flutter/widgets.dart' show Color, HSVColor;

int toIntByte(double x) {
  return x.toInt().clamp(0, 255);
}

Color fromHSVtoColor(HSVColor color) {
  double hue = color.hue,
      saturation = color.saturation,
      value = color.value,
      alpha = color.alpha;

  int alphaInt = toIntByte(alpha * 0xFF);
  if (saturation == 0.0)
    return Color.fromARGB(
        alphaInt, toIntByte(value), toIntByte(value), toIntByte(value));
  int i = (hue * 6.0).toInt(); // Assume int truncates.
  double f = (hue * 6.0) - i;
  int p = toIntByte(value * (1.0 - saturation));
  int q = toIntByte(value * (1.0 - saturation * f));
  int t = toIntByte(value * (1.0 - saturation * (1.0 - f)));
  int valueInt = toIntByte(value);

  i = i % 6;

  switch (i) {
    case 0:
      return Color.fromARGB(alphaInt, valueInt, t, p);
      break;
    case 1:
      return Color.fromARGB(alphaInt, q, valueInt, p);
      break;
    case 2:
      return Color.fromARGB(alphaInt, p, valueInt, t);
      break;
    case 3:
      return Color.fromARGB(alphaInt, p, q, valueInt);
      break;
    case 4:
      return Color.fromARGB(alphaInt, t, p, valueInt);
      break;
    case 5:
      return Color.fromARGB(alphaInt, valueInt, p, q);
      break;
    default:
      return Color.fromARGB(alphaInt, valueInt, valueInt, valueInt);
  }
}
