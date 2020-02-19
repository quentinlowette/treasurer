import 'package:flutter/foundation.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/storage.service.dart';

class CounterViewModel extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  StorageService _storageService = locator<StorageService>();

  Future loadData() async {
    _counter = await _storageService.getValue();
    notifyListeners();
  }

  void increment() {
    _counter++;
    _storageService.setValue(_counter);
    notifyListeners();
  }
}
