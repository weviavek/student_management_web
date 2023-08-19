import 'package:flutter/material.dart';

ValueNotifier<bool> imageNotifier = ValueNotifier(false);

ValueNotifier<bool> listNotifier = ValueNotifier(false);

ValueNotifier<bool> detailsNotifier = ValueNotifier(false);

class Notifiers extends ChangeNotifier {
  static notifyImage() {
    imageNotifier.notifyListeners();
  }

  static notifyList() {
    listNotifier.notifyListeners();
  }

  static notifyDetails() {
    detailsNotifier.notifyListeners();
  }
}
