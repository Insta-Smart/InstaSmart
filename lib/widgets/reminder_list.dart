import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'checkbox.dart';
import 'package:instasmart/models/reminder_data.dart';
import 'package:instasmart/screens/reminder_form.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({
    Key key,
    @required List selectedEvents,
  })  : _selectedEvents = selectedEvents,
        super(key: key);

  final List _selectedEvents;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _selectedEvents
          .map((reminder) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(reminder.caption),
                        ),
                        Expanded(child: ReminderCheckbox(reminder)),
                      ],
                    ),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReminderForm(reminder),
                              ))
                        },
                    leading: Hero(tag: reminder.id, child: reminder.picture)),
              ))
          .toList(),
    );
  }
}
