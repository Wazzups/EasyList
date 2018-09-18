class ConstantsFilter {
  static const String History = 'History';
  static const String All = 'All';

  static const List<String> choices = <String>[All, History];
}

class ConstantsOrder {
  static const String Price = 'Sort by Price';
  static const String Location = 'Sort by Location';

  static const List<String> choices = <String>[Price, Location];
}

class ConstantsFloatingButton {
  static const String Manual = 'Manual';
  static const String Barcode = 'Barcode';

  static const List<String> choices = <String>[Barcode, Manual];
}
