import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddOperationView extends StatefulWidget {
  @override
  _AddOperationViewState createState() => _AddOperationViewState();
}

class _AddOperationViewState extends State<AddOperationView> {
  bool _isCash = false;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime _date;

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
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                    // color: Colors.white,
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_center_focus),
                    onPressed: () => print("scan"),
                    // color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                "New operation",
                style: Theme.of(context).textTheme.headline3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 60.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      controller: _descriptionController,
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Montant',
                      ),
                      keyboardType: TextInputType.number,
                      controller: _amountController,
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      onPressed: _selectDate,
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: _date == null
                          ? Icon(Icons.today)
                          : Text(DateFormat('dd/MM/yyyy').format(_date)),
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
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      onPressed: () => print("submit"),
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
    );
  }
}
