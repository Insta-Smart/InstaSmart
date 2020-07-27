// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/preview_screen/components/bottom_sheet_options.dart';
import 'package:instasmart/services/notifications.dart';
import 'package:instasmart/services/reminder_data.dart';
import 'package:instasmart/utils/size_config.dart';

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
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PageTopBar(
        appBar: AppBar(),
        title: 'Edit Reminder',
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              // context,
              key: _fbKey,
              autovalidate: true,
              readOnly: false,
              child: Column(
                children: <Widget>[
                  Center(
                      child: Container(
                    width: SizeConfig.screenWidth / 1.5,
                    height: SizeConfig.screenWidth / 1.5,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => BottomSheetOptions(
                                  imageUrl: widget.reminder.pictureUrl,
                                  screen: 'Calendar',
                                ));
                      },
                      child: Hero(
                        tag: widget.reminder.id,
                        child: Image.network(widget.reminder.pictureUrl),
                      ),
                    ),
                  )),
                  SizedBox(height: SizeConfig.blockSizeVertical * 7),
                  FormBuilderTextField(
                    attribute: "caption",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.chat_bubble_outline),
                      labelText: "Caption",
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25.0),
                        ),
                      ),
                    ),
                    initialValue: widget.reminder.caption,
                    onChanged: _onChanged,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  FormBuilderDateTimePicker(
                    attribute: "postTime",
                    onChanged: _onChanged,
                    format: DateFormat("dd-MM-yyyy HH:mm"),
                    inputType: InputType.both,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.timer),
                      labelText: "Time to post",
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25.0),
                        ),
                      ),
                    ),
                    validator: (val) => null,
                    initialTime: TimeOfDay.now(),
                    initialValue: widget.reminder.postTime,
                    // readonly: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  height: SizeConfig.blockSizeVertical * 10,
                  child: RaisedButton(
                    elevation: 5,
                    shape: Constants.buttonShape,
                    color: Constants.lightPurple,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Update",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (_fbKey.currentState.saveAndValidate()) {
                        var formValues = _fbKey.currentState.value;
                        var notifications = LocalNotifications();
                        await notifications.initializing();
                        notifications
                            .cancelNotification(widget.reminder.postTime);
                        widget.reminder.caption = formValues['caption'];
                        widget.reminder.postTime = formValues['postTime'];
                        ReminderData().updateReminder(widget.reminder);
                        notifications
                            .scheduleNotification(widget.reminder.postTime);
                        Navigator.pop(context);
                      } else {
                        print(_fbKey.currentState.value);
                        print("validation failed");
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  height: SizeConfig.blockSizeVertical * 10,
                  child: RaisedButton(
                    elevation: 5,
                    shape: Constants.buttonShape,
                    color: Constants.palePink,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Delete",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                        var notifications = LocalNotifications();
                        await notifications.initializing();
                        notifications
                            .cancelNotification(widget.reminder.postTime);
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
