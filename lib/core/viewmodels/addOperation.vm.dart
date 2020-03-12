import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/services/textRecognition.service.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';

/// ViewModel of the AddOperation View
class AddOperationViewModel extends ChangeNotifier {
  /// Loading status
  bool _isLoading = false;

  /// Image File associated to the operation
  File _imageFile;

  String _detectedAmountString;

  DateTime _detectedDate;

  String get detectedAmountString => _detectedAmountString;

  DateTime get detectedDate => _detectedDate;

  bool get isLoading => _isLoading;

  File get imageFile => _imageFile;

  /// Instance of the text recognition service
  TextRecognitionService _textRecognitionService = locator<TextRecognitionService>();

  /// Instance of the navigation service
  NavigationService _navigationService = locator<NavigationService>();

  // TODO clean
  ///// Instance of the account view model
  ////AccountViewModel _accountViewModel = locator<AccountViewModel>();

  Operation _operation;

  void exit() {
    if (_imageFile != null) {
      _imageFile.delete();
    }

    _navigationService.goBack<Operation>(_operation);
  }

  /// Displays the image picker with the camera
  Future<void> getImage() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);

    // If picked image is null
    if (pickedImage == null) {
      return;
    }

    // If there was a previous image
    if (_imageFile != null) {
      _imageFile.delete();
    }

    _imageFile = pickedImage;
    notifyListeners();
  }

  Future<void> scanImage() async {
    _isLoading = true;
    notifyListeners();

    await _textRecognitionService.detect(_imageFile);

    _detectedAmountString = _textRecognitionService.total.toString().replaceAll('.', ',');
    _detectedDate = _textRecognitionService.date;
    _isLoading = false;
    notifyListeners();
  }

  /// Creates a new operation
  void commitOperation(String amountText, DateTime date, String descriptionText, bool isCash, bool isPositive) {
    _operation = Operation(
        amount: isPositive
            ? double.parse(amountText.replaceAll(',', '.'))
            : -1 * double.parse(amountText.replaceAll(',', '.')),
        date: date,
        description: descriptionText,
        isCash: isCash,
        receiptPhotoPath: _imageFile == null ? null : _imageFile.path);
    // _accountViewModel.addOperation(operation);
    exit();
  }
}
