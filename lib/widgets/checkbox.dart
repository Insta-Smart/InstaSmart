import 'package:flutter/material.dart';

class ReminderCheckbox extends StatefulWidget {
  @override
  _ReminderCheckboxState createState() => _ReminderCheckboxState();
}

class _ReminderCheckboxState extends State<ReminderCheckbox> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
        value: checked,
        onChanged: (bool value) {
          setState(() {
            checked = value;
          });
        },
      ),
    );
  }
}

