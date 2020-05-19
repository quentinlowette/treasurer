import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/operation_editor.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/theme.dart';
import 'package:treasurer/ui/widgets/buttons.dart';
import 'package:treasurer/ui/widgets/operation_editor_field.dart';

/// View of the Operation's Editor
class OperationEditorView extends StatelessWidget {
  final Operation initialOperation;

  const OperationEditorView({Key key, @required this.initialOperation})
      : super(key: key);

  /// Displays the date picker and sets the [_date] variable
  Future<void> _selectDate(
      BuildContext context, OperationEditorViewModel model) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: model.date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != model.date) {
      model.setDate(pickedDate);
    }
  }

  void _selectActor(BuildContext context, Actor currentActor,
      Actor differentFrom, void Function(Actor actor) onTap) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: DefaultThemeColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  )),
              child: Wrap(
                children: ActorType.values.map((actorType) {
                  Color color;
                  Actor actor = Actor(actorType);

                  if (currentActor != null && currentActor.hasType(actorType)) {
                    color = DefaultThemeColors.blue;
                  } else if (differentFrom != null &&
                      differentFrom.hasType(actorType)) {
                    color = DefaultThemeColors.black.withAlpha(120);
                  } else {
                    color = DefaultThemeColors.black;
                  }

                  return ListTile(
                    title: Text(
                      actor.toString(),
                      style: TextStyle(color: color),
                    ),
                    enabled: differentFrom == null ||
                        !differentFrom.hasType(actorType),
                    onTap: () {
                      onTap(actor);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OperationEditorViewModel>.reactive(
        viewModelBuilder: () =>
            OperationEditorViewModel(initialOperation: initialOperation),
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async {
              model.deleteImage();
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(initialOperation == null
                    ? "Nouvelle opération"
                    : "Modifier l'opération"),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: CustomTheme.gradient,
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: <Widget>[
                    model.isLoading ? LinearProgressIndicator() : Container(),
                    SizedBox(
                      height: 16.0,
                    ),
                    OperationEditorField(
                      title: "Montant",
                      isValid: model.isAmountValid,
                      alignment: CrossAxisAlignment.start,
                      onTap: null,
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: '0.0',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: model.isAutoFilled
                                ? DefaultThemeColors.orange
                                : DefaultThemeColors.black),
                        keyboardType: TextInputType.number,
                        controller: model.amountController,
                      ),
                    ),
                    OperationEditorField(
                      title: "Description",
                      isValid: model.isDescriptionValid,
                      alignment: CrossAxisAlignment.start,
                      onTap: null,
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nouvelle opération',
                          border: InputBorder.none,
                        ),
                        controller: model.descriptionController,
                      ),
                    ),
                    OperationEditorField(
                      title: "Date",
                      isValid: model.isDateValid,
                      alignment: CrossAxisAlignment.start,
                      onTap: () => _selectDate(context, model),
                      subtitle: Container(
                        height: 48.0,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.date != null
                              ? DateFormat('dd/MM/yyyy').format(model.date)
                              : "Veuillez choisir une date",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: model.isAutoFilled
                                  ? DefaultThemeColors.orange
                                  : DefaultThemeColors.black),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        OperationEditorField(
                          title: "Source",
                          isValid: model.issourceValid,
                          alignment: CrossAxisAlignment.start,
                          onTap: () => _selectActor(context, model.sourceActor,
                              model.destinationActor, (actor) {
                            model.setSource(actor);
                          }),
                          subtitle: Container(
                            height: 48.0,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              model.sourceActor != null
                                  ? model.sourceActor.toString()
                                  : "Source",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                        OperationEditorField(
                          title: "Destination",
                          isValid: model.isdestinationValid,
                          alignment: CrossAxisAlignment.end,
                          onTap: () => _selectActor(
                              context,
                              model.destinationActor,
                              model.sourceActor, (actor) {
                            model.setDestination(actor);
                          }),
                          subtitle: Container(
                            height: 48.0,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              model.destinationActor != null
                                  ? model.destinationActor.toString()
                                  : "Destination",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 82.0,
                    ),
                    CustomOutlineButton(
                      onPressed: () {
                        model.getAndScanImage();
                      },
                      title: "Scanner une photo",
                      outlineColor: DefaultThemeColors.blue,
                      textColor: DefaultThemeColors.blue,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    CustomRaisedButton(
                      onPressed: () {
                        if (model.validateFields()) {
                          model.commitOperation();
                        } else {
                          model.rebuild();
                        }
                      },
                      title: "Ajouter",
                      backgroundColor: DefaultThemeColors.blue,
                      textColor: DefaultThemeColors.white,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
