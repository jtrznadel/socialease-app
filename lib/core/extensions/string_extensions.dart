extension StringExt on String {
  String get obscureEmail {
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);

    username = '${username[0]}****${username[username.length - 1]}';
    return '$username@$domain';
  }

  String get getDistance {
    double distance = double.tryParse(this) ?? 0.0;
    if (distance < 1000) {
      return '${distance.round()} m';
    } else {
      double distanceInKm = distance / 1000;
      return '${distanceInKm.toStringAsFixed(2)} km';
    }
  }
}
