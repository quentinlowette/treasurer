import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/textRecognition.service.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/widgets/imageMiniature.dart';

class AddOperationView extends StatefulWidget {
  @override
  _AddOperationViewState createState() => _AddOperationViewState();
}

class _AddOperationViewState extends State<AddOperationView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isCash = false;
  bool _isPositive = false;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime _date;
  File _imageFile;
  bool _isLoading = false;

  /// Instance of the text recognition service
  TextRecognitionService _textRecognitionService =
      locator<TextRecognitionService>();

  /// Displays the image picker with the camera
  Future<void> _getImage() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);

    // If picked image is null
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // If there was a previous image
    if (_imageFile != null) {
      _imageFile.delete();
    }

    await _textRecognitionService.detect(pickedImage);

    setState(() {
      _imageFile = pickedImage;
      _amountController.text =
          _textRecognitionService.total.toString().replaceAll('.', ',');
      _date = _textRecognitionService.date;
      _isLoading = false;
    });
  }

  /// Displays the date picker and sets the date variable
  Future<void> _selectDate() async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != _date) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  /// Validates the form fields and creates a new operation
  Operation _validateInputs(int nextOperationIndex) {
    if (_formKey.currentState.validate() && _date != null) {
      Operation newOperation = Operation(
          amount: _isPositive
              ? double.parse(_amountController.text.replaceAll(',', '.'))
              : -1 * double.parse(_amountController.text.replaceAll(',', '.')),
          date: _date,
          description: _descriptionController.text,
          id: nextOperationIndex,
          isCash: _isCash,
          receiptPhotoPath: _imageFile == null ? null : _imageFile.path);
      return newOperation;
    } else {
      setState(() {
        _autoValidate = true;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AccountViewModel>.withConsumer(
        viewModel: locator<AccountViewModel>(),
        reuseExisting: true,
        builder: (context, model, child) {
          return Scaffold(
            // appBar: AppBar(
            //   actions: <Widget>[
            //     IconButton(
            //       icon: Icon(Icons.filter_center_focus),
            //       onPressed: _getImage,
            //     )
            //   ],
            // ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              if (_imageFile != null) {
                                _imageFile.delete();
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.filter_center_focus),
                            onPressed: _getImage,
                          ),
                        ],
                      ),
                      _isLoading ? LinearProgressIndicator() : Container(),
                      SizedBox(height: 30.0),
                      // Text(
                      //   "New operation",
                      //   style: Theme.of(context).textTheme.headline2,
                      // ),
                      // SizedBox(height: 30.0),
                      ImageMiniature(
                        imageFile: _imageFile,
                      ),
                      SizedBox(height: 30.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                              ),
                              controller: _descriptionController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: _isPositive
                                      ? Icon(Icons.add)
                                      : Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      _isPositive ^= true;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Montant',
                                      suffixIcon: Icon(Icons.euro_symbol),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _amountController,
                                    validator: (value) {
                                      Pattern amountPattern =
                                          r'^[1-9][0-9]*([\.,][0-9]+)?$';
                                      RegExp amountRegex =
                                          RegExp(amountPattern);
                                      if (!amountRegex.hasMatch(value)) {
                                        return 'Please enter a valid amount';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            RaisedButton(
                              onPressed: _selectDate,
                              color: _autoValidate && _date == null
                                  ? Theme.of(context).errorColor
                                  : Theme.of(context).accentColor,
                              textColor: Colors.white,
                              child: _date == null
                                  ? Icon(Icons.today)
                                  : Text(
                                      DateFormat('dd/MM/yyyy').format(_date)),
                            ),
                            SizedBox(height: 20.0),
                            CheckboxListTile(
                              value: this._isCash,
                              onChanged: (checked) {
                                setState(() {
                                  this._isCash = checked;
                                });
                              },
                              title: Text("Cash ?"),
                              activeColor: Theme.of(context).accentColor,
                            ),
                            SizedBox(height: 20.0),
                            RaisedButton(
                              onPressed: () {
                                Operation newOp =
                                    _validateInputs(model.nextOperationIndex);
                                if (newOp != null) {
                                  model.addOperation(newOp);
                                  Navigator.of(context).pop();
                                }
                              },
                              color: Theme.of(context).accentColor,
                              textColor: Colors.white,
                              child: Text("Add"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
