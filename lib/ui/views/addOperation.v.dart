import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/addOperation.vm.dart';
import 'package:treasurer/ui/widgets/imageMiniature.dart';

class AddOperationView extends StatefulWidget {
  final Operation initialOperation;

  AddOperationView({@required this.initialOperation});

  @override
  _AddOperationViewState createState() => _AddOperationViewState();
}

class _AddOperationViewState extends State<AddOperationView> {
  /// Global key of the form
  ///
  /// Needed for the Form widget
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Auto validate status
  bool _autoValidate = false;

  /// Auto filled status
  bool _autoFilled = false;

  /// Cash status
  bool _isCash = false;

  /// Positive status
  bool _isPositive = false;

  /// Controller of the description input
  TextEditingController _descriptionController = TextEditingController();

  /// Controller of the amount input
  TextEditingController _amountController = TextEditingController();

  /// Selected DateTime
  DateTime _date;

  @override
  void initState() {
    super.initState();

    // Initializes the fields if there is an initial operation
    if (widget.initialOperation != null) {
      _descriptionController.text = widget.initialOperation.description;
      _amountController.text = widget.initialOperation.amount.abs().toString();
      _date = widget.initialOperation.date;
      _isCash = widget.initialOperation.isCash;
      _isPositive = widget.initialOperation.amount >= 0;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Displays the date picker and sets the [_date] variable
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

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AddOperationViewModel>.withConsumer(
        viewModel:
            AddOperationViewModel(initialOperation: widget.initialOperation),
        builder: (context, model, child) {
          return Scaffold(
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
                            onPressed: () => model.exit(),
                          ),
                          IconButton(
                              icon: Icon(Icons.filter_center_focus),
                              onPressed: () {
                                model.getImage();
                                model.scanImage();
                                setState(() {
                                  _amountController.text =
                                      model.detectedAmountString;
                                  _date = model.detectedDate;
                                  _autoFilled = true;
                                });
                              }),
                        ],
                      ),
                      model.isLoading ? LinearProgressIndicator() : Container(),
                      SizedBox(height: 30.0),
                      // Text(
                      //   "New operation",
                      //   style: Theme.of(context).textTheme.headline2,
                      // ),
                      // SizedBox(height: 30.0),
                      ImageMiniature(
                        imageFile: model.imageFile,
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
                                      icon: _autoFilled ? Icon(Icons.warning) : null,
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
                                if (_formKey.currentState.validate() &&
                                    _date != null) {
                                  model.commitOperation(
                                      _amountController.text,
                                      _date,
                                      _descriptionController.text,
                                      _isCash,
                                      _isPositive);
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
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
