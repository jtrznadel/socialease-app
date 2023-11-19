extension IntExt on int {
  String get pluralize {
    return (this > 1 || this == 0) ? 's' : '';
  }
}
