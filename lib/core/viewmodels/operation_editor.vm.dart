import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/services/text_recognition.service.dart';

/// View Model of the OperationEditor View.
class OperationEditorViewModel extends ChangeNotifier {
  /// The loading status.
  bool _isLoading = false;

  /// The image file associated to the operation.
  File _imageFile;

  /// The detected amount's string.
  String _detectedAmountString;

  /// The detected date.
  DateTime _detectedDate;

  /// The auto filled status.
  bool _autoFilled = false;

  /// The controller of the description input.
  TextEditingController _descriptionController = TextEditingController();

  /// The controller of the amount input.
  TextEditingController _amountController = TextEditingController();

  /// The selected [DateTime].
  DateTime _date;

  /// The selected source [Actor]
  Actor _sourceActor;

  /// The selected destination [Actor]
  Actor _destinationActor;

  /// The validation's flag for the description.
  bool _descriptionValid = true;

  /// The validation's flag for the amount.
  bool _amountValid = true;

  /// The validation's flag for the date.
  bool _dateValid = true;

  /// The validation's flag for the source.
  bool _sourceValid = true;

  /// The validation's flag for the destination.
  bool _destinationValid = true;

  OperationEditorViewModel({@required Operation initialOperation}) {
    _initialOperation = initialOperation;

    // Initializes the fields if there is an initial operation.
    if (initialOperation != null) {
      _descriptionController.text = initialOperation.description;
      _amountController.text = initialOperation.amount.abs().toString();
      _date = initialOperation.date;
      _sourceActor = initialOperation.source;
      _destinationActor = initialOperation.destination;

      // If there is an associated image file.
      if (initialOperation.receiptPhotoPath != null) {
        _imageFile = File(initialOperation.receiptPhotoPath);
      }
    }
  }

  /// The getter for the auto filled status.
  bool get isAutoFilled => _autoFilled;

  /// The getter for the controller of the description input.
  TextEditingController get descriptionController => _descriptionController;

  /// The getter for the controller of the amount input.
  TextEditingController get amountController => _amountController;

  /// The getter for the selected [DateTime].
  DateTime get date => _date;

  /// The getter for the selected source [Actor].
  Actor get sourceActor => _sourceActor;

  /// The getter for the selected destination [Actor].
  Actor get destinationActor => _destinationActor;

  /// The getter for the description validation's flag.
  bool get isDescriptionValid => _descriptionValid;

  /// The getter for the amount validation's flag.
  bool get isAmountValid => _amountValid;

  /// The getter for the date validation's flag.
  bool get isDateValid => _dateValid;

  /// The getter for the source validation's flag.
  bool get issourceValid => _sourceValid;

  /// The getter for the destination validation's flag.
  bool get isdestinationValid => _destinationValid;

  /// The getter for the detected amount's string.
  String get detectedAmountString => _detectedAmountString;

  /// The getter for the detected date.
  DateTime get detectedDate => _detectedDate;

  /// The getter for the loading status.
  bool get isLoading => _isLoading;

  /// The getter for the image's fiel.
  File get imageFile => _imageFile;

  /// An instance of the [TextRecognitionService].
  TextRecognitionService _textRecognitionService =
      locator<TextRecognitionService>();

  /// An instance of the [NavigationService].
  NavigationService _navigationService = locator<NavigationService>();

  /// The initial operation.
  Operation _initialOperation;

  /// Refreshes the view.
  void rebuild() {
    notifyListeners();
  }

  /// Deletes the receipt picture.
  void deleteImage() {
    // If a picture has been taken.
    if (_imageFile != null) {
      _imageFile.delete();
    }
  }

  /// Exits the view.
  void exit([Operation operation]) {
    _navigationService.goBack<Operation>(operation);
  }

  /// Sets the date.
  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  /// Sets the source actor.
  void setSource(Actor actor) {
    _sourceActor = actor;
    notifyListeners();
  }

  /// Sets the destination actor.
  void setDestination(Actor actor) {
    _destinationActor = actor;
    notifyListeners();
  }

  /// Fetches an image and scans it.
  ///
  /// Fills the date and total fields according to the detected information.
  Future<void> getAndScanImage() async {
    await getImage();

    // If an image was taken
    if (_imageFile != null) {
      await scanImage();
      _amountController.text = _detectedAmountString;
      _date = _detectedDate;
      _autoFilled = true;

      notifyListeners();
    }
  }

  /// Displays the image picker with the camera.
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

  /// Scans the receipt image and sets the variables with the detected
  /// information.
  Future<void> scanImage() async {
    _isLoading = true;

    notifyListeners();

    TextRecognitionServiceResponse response =
        await _textRecognitionService.detect(_imageFile);

    _detectedAmountString = response.total.toString().replaceAll('.', ',');
    _detectedDate = response.date;
    _isLoading = false;

    notifyListeners();
  }

  /// Validates the different fields of the form.
  ///
  /// Returns `true` if all fields are valid.
  bool validateFields() {
    Pattern amountPattern = r'^[1-9][0-9]*([\.,][0-9]+)?$';
    RegExp amountRegex = RegExp(amountPattern);

    _descriptionValid = _descriptionController.text != "";
    _amountValid = _amountController.text != "" &&
        amountRegex.hasMatch(_amountController.text);
    _dateValid = _date != null;
    _sourceValid = _sourceActor != null;
    _destinationValid = _destinationActor != null;

    return _descriptionValid &&
        _amountValid &&
        _dateValid &&
        _sourceValid &&
        _destinationValid;
  }

  /// Creates a new [Operation] and exit the view.
  void commitOperation() {
    // Creates a new Operation
    Operation newOperation = Operation(
        double.parse(_amountController.text.replaceAll(',', '.')),
        _date,
        _descriptionController.text,
        _sourceActor,
        _destinationActor,
        _imageFile == null ? null : _imageFile.path,
        _initialOperation == null ? null : _initialOperation.id);

    // Exits the view
    exit(newOperation);
  }
}
