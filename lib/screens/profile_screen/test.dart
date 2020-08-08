import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/generate_grid/create_grid_screen.dart';
import 'package:instasmart/screens/help_screen/help_screen.dart';
import 'package:instasmart/screens/onboarding_screen/onboarding_end_screen.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:instasmart/utils/size_config.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../HomeScreen.dart';
import '../signup_screen/signup_screen.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    User user = MyAppState.currentUser;
    SizeConfig().init(context);
    final userRef = Firestore.instance.collection('Users');
    final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();
    print("current user in my app in profile: ${MyAppState.currentUser.uid}");
    bool darkMode = user.darkMode;

    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SettingsList(
        sections: [
          
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(title: user.firstName, leading: Icon(Icons.perm_identity)),
              SettingsTile(title: user.email, leading: Icon(Icons.email)),
              SettingsTile(title: 'Log out', leading: Icon(Icons.exit_to_app),
              onTap: () async {
                  user.active = false;
                  user.lastOnlineTimestamp = Timestamp.now();
                  await firebase.updateUserData(user.toJson());
                  await firebase.signOut();
                  MyAppState.currentUser = null;
                  pushAndRemoveUntil(context, AuthScreen(), false);
                  },),
            ],
          ),
          SettingsSection(
            title: 'Misc',
            tiles: [
              SettingsTile.switchTile(
                title: 'Dark Mode',
                leading: Icon(Icons.highlight),
                switchValue: darkMode,
                onToggle: (bool value) {
                  setState(() {
                    darkMode = value;
                  });
                  AdaptiveTheme.of(context).toggleThemeMode();
                  user.toggleDark();



                },
              ),
              SettingsTile(
                  title: 'User Guide', leading: Icon(Icons.help),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpScreen(),
                    ));
              },),
              SettingsTile(
                  title: 'Get in Touch',
                  leading: Icon(Icons.alternate_email)),
            ],
          )
        ],
      ),
      );

  }
}