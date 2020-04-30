import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/operation_editor.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/widgets/actor_picker.dart';
import 'package:treasurer/ui/widgets/buttons.dart';
import 'package:treasurer/ui/widgets/header_clipper.dart';
import 'package:treasurer/ui/widgets/image_miniature.dart';

/// View of the Operation's Editor
class OperationEditorView extends StatefulWidget {
  final Operation initialOperation;

  const OperationEditorView({Key key, @required this.initialOperation})
      : super(key: key);

  @override
  _OperationEditorViewState createState() => _OperationEditorViewState();
}

class _OperationEditorViewState extends State<OperationEditorView> {
  /// Global key of the form
  ///
  /// Needed for the Form widget
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Auto validate status
  bool _autoValidate = false;

  /// Auto filled status
  bool _autoFilled = false;

  /// Controller of the description input
  TextEditingController _descriptionController = TextEditingController();

  /// Controller of the amount input
  TextEditingController _amountController = TextEditingController();

  /// Selected DateTime
  DateTime _date;

  /// Selected source Actor
  Actor _srcActor;

  /// Selected destination Actor
  Actor _dstActor;

  @override
  void initState() {
    super.initState();

    // Initializes the fields if there is an initial operation
    if (widget.initialOperation != null) {
      _descriptionController.text = widget.initialOperation.description;
      _amountController.text = widget.initialOperation.amount.abs().toString();
      _date = widget.initialOperation.date;
      _srcActor = widget.initialOperation.src;
      _dstActor = widget.initialOperation.dst;
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
    return ViewModelBuilder<OperationEditorViewModel>.reactive(
        viewModelBuilder: () => OperationEditorViewModel(initialOperation: widget.initialOperation),
        builder: (context, model, child) {
          return Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: <Widget>[
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: <Widget>[
                    //     IconButton(
                    //       icon: Icon(Icons.arrow_back_ios),
                    //       onPressed: () => model.exit(),
                    //     ),
                    //     Text(
                    //       "Nouvelle opération",
                    //       style: Theme.of(context).textTheme.headline6.copyWith(
                    //         color: DefaultThemeColors.blue
                    //       ),
                    //     )
                        // IconButton(
                        //     icon: Icon(Icons.filter_center_focus),
                        //     onPressed: () {
                        //       model.getImage();
                        //       // If an image has been taken
                        //       if (model.imageFile != null) {
                        //         model.scanImage();
                        //         setState(() {
                        //           _amountController.text =
                        //               model.detectedAmountString;
                        //           _date = model.detectedDate;
                        //           _autoFilled = true;
                        //         });
                        //       }
                        //     }),
                    //   ],
                    // ),
                    //! model.isLoading ? LinearProgressIndicator() : Container(),
                    // SizedBox(height: 30.0),
                    // Text(
                    //   "New operation",
                    //   style: Theme.of(context).textTheme.headline2,
                    // ),
                    // SizedBox(height: 30.0),
                    // ImageMiniature(
                    //   imageFile: model.imageFile,
                    // ),
                    // SizedBox(height: 30.0),
                    ClipPath(
                          clipper: HeaderClipper(),
                          child: Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.1, 0.4, 0.7, 0.9],
                                colors: [
                                  DefaultThemeColors.blue1,
                                  DefaultThemeColors.blue2,
                                  DefaultThemeColors.blue3,
                                  DefaultThemeColors.blue4,
                                ],
                              ),
                            ),
                          ),
                        ),
                    SafeArea(
                      child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: DefaultThemeColors.white,
                              onPressed: () => model.exit(),
                            ),
                            Text(
                              "Nouvelle opération",
                              style: Theme.of(context).textTheme.headline6.copyWith(
                                color: DefaultThemeColors.white
                              ),
                            )
                          ]
                        ),
                        SizedBox(height: 8.0,),
                        Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Montant',
                                    hintStyle: Theme.of(context).accentTextTheme.headline4.copyWith(
                                      color: DefaultThemeColors.white.withAlpha(150)
                                    ),
                                    icon: _autoFilled ? Icon(Icons.warning) : null,
                                    border: InputBorder.none,
                                  ),
                                  cursorColor: DefaultThemeColors.white,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).accentTextTheme.headline4,
                                  keyboardType: TextInputType.number,
                                  controller: _amountController,
                                  validator: (value) {
                                    Pattern amountPattern =
                                        r'^[1-9][0-9]*([\.,][0-9]+)?$';
                                    RegExp amountRegex = RegExp(amountPattern);
                                    if (!amountRegex.hasMatch(value)) {
                                      return 'Please enter a valid amount';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24.0),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Description',
                                  ),
                                  controller: _descriptionController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 32.0),
                                // TextFormField(
                                //   decoration: InputDecoration(
                                //     hintText: 'Date',
                                //   ),
                                //   onTap: _selectDate,
                                // ),
                        // GestureDetector(
                        //   onTap: _selectDate,
                        //   // color: _autoValidate && _date == null
                        //   //     ? Theme.of(context).errorColor
                        //   //     : Theme.of(context).accentColor,
                        //   // textColor: Colors.white,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(vertical: 14.0),
                        //     decoration: BoxDecoration(
                        //       border: Border(
                        //         bottom: BorderSide(
                        //           width: 1.0,
                        //           color: DefaultThemeColors.black
                        //         )
                        //       )
                        //     ),
                        //     child: _date == null
                        //       // ? Icon(Icons.today)
                        //       ? Text("Description", style: Theme.of(context).textTheme.subtitle1,)
                        //       : Text(DateFormat('dd/MM/yyyy').format(_date)),
                        //   )
                        // ),
                                CustomRaisedButton(
                                  backgroundColor: DefaultThemeColors.blue,
                                  textColor: DefaultThemeColors.white,
                                  title: _date == null ? "Date" : DateFormat('dd/MM/yyyy').format(_date),
                                  onPressed: _selectDate,
                                ),
                                SizedBox(height: 20.0),
                                ActorPicker(
                                  title: Text("Source"),
                                  currentActor: _srcActor,
                                  differentFrom: _dstActor,
                                  onTap: (actor) {
                                    setState(() {
                                      _srcActor = actor;
                                    });
                                  },
                                ),
                                SizedBox(height: 20.0),
                                ActorPicker(
                                  title: Text("Destination"),
                                  currentActor: _dstActor,
                                  differentFrom: _srcActor,
                                  onTap: (actor) {
                                    setState(() {
                                      _dstActor = actor;
                                    });
                                  },
                                ),
                                SizedBox(height: 20.0),
                                CustomRaisedButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate() &&
                                        _date != null &&
                                        _srcActor != null &&
                                        _dstActor != null) {
                                      model.commitOperation(
                                          _amountController.text,
                                          _date,
                                          _descriptionController.text,
                                          _srcActor,
                                          _dstActor);
                                    } else {
                                      setState(() {
                                        _autoValidate = true;
                                      });
                                    }
                                  },
                                  title: "Ajouter",
                                  backgroundColor: DefaultThemeColors.blue,
                                  textColor: DefaultThemeColors.white,
                                ),
                                SizedBox(height: 20.0),
                              ]
                            ),
                          )
                        )
                      ],
                    ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
