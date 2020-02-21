import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/storage.service.dart';

class AccountViewModel extends ChangeNotifier {
  List<Operation> _operations;

  List<Operation> get operations => _operations;

  StorageService _storageService = locator<StorageService>();

  Future loadData() async {
    _operations = await _storageService.getOperations();
    notifyListeners();
  }
}
