// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/screens/calendar_screen/components/reminder_checkbox.dart';
import 'package:instasmart/screens/reminder_screen/reminder_modify_form.dart';

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
                  boxShadow: [
//          if (showElevation)
                    const BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 0.75),
                      blurRadius: 3,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(child: Text(reminder.caption)),
                        ReminderCheckbox(reminder),
                      ],
                    ),
                    onTap: () => {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ReminderForm(reminder),
                            ),
                          ),

                        },
                    leading: Hero(tag: reminder.id, child: reminder.picture)),
              ))
          .toList(),
    );
  }
}
