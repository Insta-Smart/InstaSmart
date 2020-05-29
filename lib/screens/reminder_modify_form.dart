import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:instasmart/models/reminder_data.dart';
import 'package:instasmart/models/reminder.dart';

class ReminderForm extends StatefulWidget {
  static const routeName = '/reminder_form';
  ReminderForm(this.reminder);
  var reminder;
  @override
  ReminderFormState createState() {
    return ReminderFormState();
  }
}

class ReminderFormState extends State<ReminderForm> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Post"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              // context,
              key: _fbKey,
              // autovalidate: true,
              readOnly: false,
              child: Column(
                children: <Widget>[
                  Center(
                      child: Container(
                    width: MediaQuery.of(context).size.width / 2.round(),
                    height: MediaQuery.of(context).size.width / 2.round(),
                    child: Hero(
                        tag: widget.reminder.id,
                        child: Image.network(widget.reminder.picture_url)),
                  )),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: "caption",
                    decoration: InputDecoration(
                      labelText: "Caption",
                    ),
                    initialValue: widget.reminder.caption,
                    onChanged: _onChanged,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormBuilderDateTimePicker(
                    attribute: "postTime",
                    onChanged: _onChanged,
                    format: DateFormat("dd-MM-yyyy HH:mm"),
                    inputType: InputType.both,
                    decoration: InputDecoration(
                      labelText: "Time to post",
                    ),
                    validator: (val) => null,
                    initialTime: TimeOfDay.now(),
                    initialValue: widget.reminder.postTime,
                    // readonly: true,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Update Reminder",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        var formValues = _fbKey.currentState.value;
                        widget.reminder.caption = formValues['caption'];
                        widget.reminder.postTime = formValues['postTime'];
                        ReminderData().updateReminder(widget.reminder);
                        Navigator.pop(context);
                      } else {
                        print(_fbKey.currentState.value);
                        print("validation failed");
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Delete Reminder",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                        ReminderData().deleteReminder(widget.reminder);
                        Navigator.pop(context);
                      } else {
                        print(_fbKey.currentState.value);
                        print("validation failed");
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
