import 'package:flutter_test/flutter_test.dart';

import 'package:soft_ui/src/color_mix.dart';

import 'package:flutter/material.dart' show Color, HSVColor;

void main() {
  // Last result: Failed
  // Test for Color conversion from HSV to RGB:
  // ahsv: 1.0 0.0 0.0 0.0784313725490196
  // ERROR: Expected: '255 20 20 20'
  //   Actual: '255 0 0 0'
  //    Which: is different.
  //           Expected: 255 20 20 20
  //             Actual: 255 0 0 0
  //                         ^
  //            Differ at offset 4
  // package:test_api                                   expect
  // package:flutter_test/src/widget_tester.dart 234:3  expect
  // test/soft_ui_test.dart 15:5                        main.<fn>
  test('Test for Color conversion from HSV to RGB', () {
    Color tColor = Color.fromARGB(255, 20, 20, 20);
    HSVColor hColor = HSVColor.fromColor(tColor);
    print(
        "ahsv: ${hColor.alpha} ${hColor.hue} ${hColor.saturation} ${hColor.value}");
    Color res = fromHSVtoColor(hColor);
    expect("${res.alpha} ${res.red} ${res.green} ${res.blue}",
        "${tColor.alpha} ${tColor.red} ${tColor.green} ${tColor.blue}");
  });
}
