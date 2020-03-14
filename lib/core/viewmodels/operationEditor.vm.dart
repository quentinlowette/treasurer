import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/services/textRecognition.service.dart';

/// ViewModel of the OperationEditor View
class OperationEditorViewModel extends ChangeNotifier {
  /// Loading status
  bool _isLoading = false;

  /// Image File associated to the operation
  File _imageFile;

  /// Detected amount's string
  String _detectedAmountString;

  /// Detected date
  DateTime _detectedDate;

  OperationEditorViewModel({@required Operation initialOperation}) {
    _initialOperation = initialOperation;
    if (initialOperation != null && initialOperation.receiptPhotoPath != null) {
      _imageFile = File(initialOperation.receiptPhotoPath);
    }
  }

  /// Getter for the detected amount's string
  String get detectedAmountString => _detectedAmountString;

  /// Getter for the detected date
  DateTime get detectedDate => _detectedDate;

  /// Getter for the loading status
  bool get isLoading => _isLoading;

  /// Getter for the image's fiel
  File get imageFile => _imageFile;

  /// Instance of the text recognition service
  TextRecognitionService _textRecognitionService =
      locator<TextRecognitionService>();

  /// Instance of the navigation service
  NavigationService _navigationService = locator<NavigationService>();

  /// Initial operation
  Operation _initialOperation;

  /// Exits the view and deletes, if needed, the taken picture
  void exit([Operation operation]) {
    // If there isn't an initial operation and if a picture has been taken
    if (_initialOperation == null && _imageFile != null) {
      _imageFile.delete();
    }
    _navigationService.goBack<Operation>(operation);
  }

  /// Displays the image picker with the camera
  Future<void> getImage() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);

    // If picker was closed
    if (pickedImage == null) {
      return;
    }

    // If there was a previous image
    if (_imageFile != null) {
      _imageFile.delete();
    }

    // Saves the picture
    _imageFile = pickedImage;

    // Notifies changes
    notifyListeners();
  }

  Future<void> scanImage() async {
    _isLoading = true;
    notifyListeners();

    await _textRecognitionService.detect(_imageFile);

    _detectedAmountString =
        _textRecognitionService.total.toString().replaceAll('.', ',');
    _detectedDate = _textRecognitionService.date;
    _isLoading = false;
    notifyListeners();
  }

  /// Creates a new operation and exit the view
  void commitOperation(String amountText, DateTime date, String descriptionText) {
    // Create a new Operation
    Operation newOperation = Operation(
        amount: double.parse(amountText.replaceAll(',', '.')),
        date: date,
        description: descriptionText,
        id: _initialOperation == null ? null : _initialOperation.id,
        src: Actor.extern,
        dst: Actor.bank,
        receiptPhotoPath: _imageFile == null ? null : _imageFile.path);

    // Exits the view
    exit(newOperation);
  }
}
