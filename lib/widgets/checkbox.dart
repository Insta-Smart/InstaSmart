import 'package:flutter/material.dart';
import 'package:instasmart/models/reminder_data.dart';

class ReminderCheckbox extends StatefulWidget {
  ReminderCheckbox(this.reminder);
  var reminder;
  @override
  _ReminderCheckboxState createState() => _ReminderCheckboxState();
}

class _ReminderCheckboxState extends State<ReminderCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
        value: widget.reminder.isPosted,
        onChanged: (bool value) {
            widget.reminder.togglePosted();
            ReminderData().updateReminder(widget.reminder);
        },
      ),
    );
  }
}

