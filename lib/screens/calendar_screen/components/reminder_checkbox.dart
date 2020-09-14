// Flutter imports:
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/services/reminder_data.dart';

class ReminderCheckbox extends StatefulWidget {
  ReminderCheckbox(this.reminder);
  final reminder;
  @override
  _ReminderCheckboxState createState() => _ReminderCheckboxState();
}

class _ReminderCheckboxState extends State<ReminderCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Colors.teal,
      value: widget.reminder.isPosted,
      onChanged: (bool value) {
        widget.reminder.togglePosted();
        ReminderData().updateReminder(widget.reminder);
        String status = value ? 'posted' : 'unposted';
        Flushbar(
            message: "Marked as $status",
            backgroundColor: Constants.lightPurple,
            duration: Duration(seconds: 1))
          ..show(context);
//
      },
    );
  }
}
