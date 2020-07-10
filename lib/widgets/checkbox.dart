import 'package:flutter/material.dart';
import 'package:instasmart/models/reminder_data.dart';

import '../constants.dart';

class ReminderCheckbox extends StatefulWidget {
  ReminderCheckbox(this.reminder);
  var reminder;
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
        String status = value ? 'posted':'unposted';
        Widget snackBar = SnackBar(
          content: Text('Marked as ${status}'),
          backgroundColor: Constants.lightPurple,
          duration: Duration(seconds: 1),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
  }
}
