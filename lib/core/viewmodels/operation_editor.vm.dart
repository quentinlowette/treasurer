import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/services/text_recognition.service.dart';

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

  /// Auto filled status
  bool _autoFilled = false;

  /// Controller of the description input
  TextEditingController _descriptionController = TextEditingController();

  /// Controller of the amount input
  TextEditingController _amountController = TextEditingController();

  /// Selected DateTime
  DateTime _date;

  /// Selected source Actor
  Actor _sourceActor;

  /// Selected destination Actor
  Actor _destinationActor;

  /// Validation's Flags
  bool _descriptionValid = true;

  bool _amountValid = true;

  bool _dateValid = true;

  bool _sourceValid = true;

  bool _destinationValid = true;

  OperationEditorViewModel({@required Operation initialOperation}) {
    _initialOperation = initialOperation;
    // Initializes the fields if there is an initial operation
    if (initialOperation != null) {
      _descriptionController.text = initialOperation.description;
      _amountController.text = initialOperation.amount.abs().toString();
      _date = initialOperation.date;
      _sourceActor = initialOperation.source;
      _destinationActor = initialOperation.destination;

      if (initialOperation.receiptPhotoPath != null) {
        _imageFile = File(initialOperation.receiptPhotoPath);
      }
    }
  }

  /// Getter for the auto filled status
  bool get isAutoFilled => _autoFilled;

  /// Getter for the controller of the description input
  TextEditingController get descriptionController => _descriptionController;

  /// Getter for the controller of the amount input
  TextEditingController get amountController => _amountController;

  /// Getter for the selected DateTime
  DateTime get date => _date;

  /// Getter for the selected source Actor
  Actor get sourceActor => _sourceActor;

  /// Getter for the selected destination Actor
  Actor get destinationActor => _destinationActor;

  // Getter for the validation's flags
  bool get isDescriptionValid => _descriptionValid;

  bool get isAmountValid => _amountValid;

  bool get isDateValid => _dateValid;

  bool get issourceValid => _sourceValid;

  bool get isdestinationValid => _destinationValid;

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

  void rebuild() {
    notifyListeners();
  }

  /// Exits the view and deletes, if needed, the taken picture
  void exit([Operation operation]) {
    // If there isn't an initial operation and if a picture has been taken
    // if (_initialOperation == null) {
    //   _imageFile.delete();
    // }
    _descriptionController.dispose();
    _amountController.dispose();
    _navigationService.goBack<Operation>(operation);
  }

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  void setSource(Actor actor) {
    _sourceActor = actor;
    notifyListeners();
  }

  void setDestination(Actor actor) {
    _destinationActor = actor;
    notifyListeners();
  }

  Future<void> getAndScanImage() async {
    await getImage();

    if (_imageFile != null) {
      await scanImage();
      _amountController.text = _detectedAmountString;
      _date = _detectedDate;
      _autoFilled = true;

      notifyListeners();
    }
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

  bool validateFields() {
    Pattern amountPattern = r'^[1-9][0-9]*([\.,][0-9]+)?$';
    RegExp amountRegex = RegExp(amountPattern);

    _descriptionValid = _descriptionController.text != "";
    _amountValid = _amountController.text != "" &&
        amountRegex.hasMatch(_amountController.text);
    _dateValid = _date != null;
    _sourceValid = _sourceActor != null;
    _destinationValid = _destinationActor != null;

    // notifyListeners();

    return _descriptionValid &&
        _amountValid &&
        _dateValid &&
        _sourceValid &&
        _destinationValid;
  }

  /// Creates a new operation and exit the view
  void commitOperation() {
    // Create a new Operation
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
