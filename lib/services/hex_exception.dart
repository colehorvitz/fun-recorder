class HexException implements Exception {
  String cause;
  HexException(this.cause);

  String toString() => 'HexException: $cause';
}
