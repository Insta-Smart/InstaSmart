import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'checkbox.dart';
import 'package:instasmart/models/reminder_data.dart';

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
                  onTap: () => {ReminderData().createReminder(caption: 'hello',picture_url: 'https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/AllFrames%2Fsample_7.jpeg?alt=media&token=2252c619-635d-489c-857b-b2ebd0398eb5')},
                  leading: reminder.picture,
                ),
              ))
          .toList(),
    );
  }
}
