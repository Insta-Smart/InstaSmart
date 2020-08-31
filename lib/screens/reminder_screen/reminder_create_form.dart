// Flutter imports:

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/components/template_button.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/services/notifications.dart';
import 'package:instasmart/services/reminder_data.dart';
import 'package:instasmart/utils/size_config.dart';
import 'package:intl/intl.dart';

class ReminderForm extends StatefulWidget {
  static const routeName = '/reminder_create';
  ReminderForm(this.imageUrl);
  final imageUrl;
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
      appBar: PageTopBar(
        title: "Schedule Post",
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (context) => Padding(
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
                      child: Hero(
                        tag: widget.imageUrl,
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
                      onChanged: _onChanged,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 3),
                    FormBuilderDateTimePicker(
                      attribute: "postTime",
                      onChanged: _onChanged,
                      format: DateFormat("dd-MM-yyyy HH:mm"),
                      initialEntryMode: DatePickerEntryMode.calendar,
                      timePickerInitialEntryMode: TimePickerEntryMode.input,
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
                      validators: [FormBuilderValidators.required()],
                      initialTime: TimeOfDay.now(),
                      initialValue:
                          DateTime.now().add(Duration(minutes: 1)).toLocal(),
                      // readonly: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TemplateButton(
                    iconType: Icons.date_range,
                    title: 'Create Reminder',
                    ontap: () async {
                      if (_fbKey.currentState.saveAndValidate()) {
                        var formValues = _fbKey.currentState.value;
                        var caption = formValues['caption'];
                        var postTime = formValues['postTime'];
                        ReminderData().createReminder(
                            caption: caption,
                            pictureUrl: widget.imageUrl,
                            postTime: postTime);
                        var notifications = LocalNotifications(context);
                        notifications.initializing();
                        print(DateTime.now().toLocal());
                        notifications.scheduleNotification(
                            postTime, MyAppState.currentUser.firstName);
                        Navigator.pop(context, 'reminder_created');
                      } else {
                        print(_fbKey.currentState.value);
                        print("validation failed");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
