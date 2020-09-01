// Flutter imports:
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
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
                    BoxShadow(
                      color: Theme.of(context).highlightColor,
                      offset: Offset(0.0, 0.75),
                      blurRadius: 3,
                    ),
                  ],
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                    onTap: () async {
                      var navigationResult = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ReminderForm(reminder),
                        ),
                      );
                      if (navigationResult == 'reminder_updated') {
                        Flushbar(
                            message: "Reminder has been updated",
                            backgroundColor: Constants.lightPurple,
                            duration: Duration(seconds: 2))
                          ..show(context);
                      }
                    },
                    leading: Hero(tag: reminder.id, child: reminder.picture)),
              ))
          .toList(),
    );
  }
}
