import 'dart:ui';

import 'hex_exception.dart';

/// An extends of [Color] which allows for direct conversion from a HexCode
/// (e.g. #FFFFFF) into a [Color].
class HexColor extends Color {
  final hexColor;
  static _convertToHex(String hexString) {
    hexString = hexString.replaceAll("#", "");
    if (hexString.length != 6) {
      throw new HexException("Invalid hex input $hexString");
    }
    hexString = "FF" + hexString;
    return int.parse(hexString, radix: 16);
  }

  HexColor(this.hexColor) : super(_convertToHex(hexColor));

  @override
  String toString() {
    return hexColor;
  }
}
