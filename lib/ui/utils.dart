String prettyFormatDuration(Duration duration) {
  String oneDigit(int n) => n.toString().padLeft(1, "0");
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String oneDigitMinute = oneDigit(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$oneDigitMinute:$twoDigitSeconds";
}

String prettyFormatTimeAgo(DateTime past) {
  final diff = DateTime.now().difference(past);
  if (diff > Duration(days: 1)) {
    return "${diff.inDays}d";
  } else if (diff > Duration(hours: 1)) {
    return "${diff.inHours}h";
  }
  return "${diff.inMinutes}m";
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

String formatDob(DateTime dt) {
  return "${dt.month}-${dt.day}-${dt.year}";
}
