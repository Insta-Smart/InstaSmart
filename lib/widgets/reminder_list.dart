import 'package:flutter/material.dart';
import 'checkbox.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({
    Key key,
    @required List selectedEvents,
  }) : _selectedEvents = selectedEvents, super(key: key);

  final List _selectedEvents;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
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
                child: Text(event.toString()),
              ),
              Expanded(child: ReminderCheckbox()),
            ],
          ),
          onTap: () => print('$event tapped!'),
          leading: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/AllFrames%2Fsample_6.jpeg?alt=media&token=451d45da-3962-4d2d-8139-96a2bacc76d5"),
        ),
      ))
          .toList(),
    );
  }
}
