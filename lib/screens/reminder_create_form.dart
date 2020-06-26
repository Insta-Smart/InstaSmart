import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:instasmart/models/reminder_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instasmart/models/notifications.dart';
import 'package:instasmart/models/reminder.dart';

class ReminderForm extends StatefulWidget {
  static const routeName = '/reminder_create';
  ReminderForm(this.imageUrl);
  var imageUrl;
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
                            tag: widget.imageUrl,
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              progressIndicatorBuilder: (context,
                                  url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress
                                          .progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),),
                      )),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: "caption",
                    decoration: InputDecoration(
                      labelText: "Caption",
                    ),
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
                    initialValue: DateTime.now().add(Duration(minutes: 1)).toLocal(),
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
                      "Create Reminder",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if (_fbKey.currentState.saveAndValidate()) {
                        var formValues = _fbKey.currentState.value;
                        var caption = formValues['caption'];
                        var postTime = formValues['postTime'];
                        ReminderData().createReminder(caption: caption, pictureUrl: widget.imageUrl, postTime: postTime);
                        var notifications = LocalNotifications();
                        await notifications.initializing();
                        print(DateTime.now().toLocal());
                        notifications.scheduleNotification(postTime);
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
