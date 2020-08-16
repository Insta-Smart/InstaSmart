import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/help_screen/help_screen.dart';
import 'package:instasmart/screens/onboarding_screen/onboarding_end_screen.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:instasmart/utils/size_config.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void _createEmail() async {
    const emailaddress =
        'mailto:orbital2k20@gmail.com?subject=InstaSmart Feedback&body=Give us your feedback here!';

    if (await canLaunch(emailaddress)) {
      await launch(emailaddress);
    } else {
      throw 'Could not Email';
    }
  }

  Widget build(BuildContext context) {
    User user = MyAppState.currentUser;
    SizeConfig().init(context);
    final userRef = Firestore.instance.collection('Users');
    final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();
    print("current user in my app in profile: ${MyAppState.currentUser.uid}");
    Future<AdaptiveThemeMode> themeMode = AdaptiveTheme.getThemeMode();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PageTopBar(
        title: 'Profile',
        appBar: AppBar(),
      ),
      body: FutureBuilder<AdaptiveThemeMode>(
          future: themeMode,
          builder: (context, snapshot) {
            bool darkMode =
                snapshot.data == AdaptiveThemeMode.light ? false : true;
            return SettingsList(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              sections: [
                SettingsSection(
                  title: 'Account',
                  tiles: [
                    SettingsTile(
                        title: user.fullName(),
                        leading: Icon(Icons.perm_identity)),
                    SettingsTile(title: user.email, leading: Icon(Icons.email)),
                    SettingsTile(
                      title: 'Log out',
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async {
                        user.active = false;
                        user.lastOnlineTimestamp = Timestamp.now();
                        await firebase.updateUserData(user.toJson());
                        await firebase.signOut();
                        MyAppState.currentUser = null;
                        pushAndRemoveUntil(context, AuthScreen(), false);
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Settings',
                  tiles: [
                    SettingsTile.switchTile(
                      title: 'Dark Mode',
                      leading: Icon(Icons.highlight),
                      switchValue: darkMode,
                      onToggle: (bool value) {
                        setState(() {
                          darkMode = !darkMode;
                        });
                        AdaptiveTheme.of(context).toggleThemeMode();
                      },
                    ),
                    SettingsTile(
                      title: 'User Guide',
                      leading: Icon(Icons.help),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpScreen(),
                            ));
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Contact',
                  tiles: [
                    SettingsTile(
                        title: 'Reach us at orbital2k20@gmail.com',
                        leading: Icon(Icons.alternate_email),
                        onTap: _createEmail),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
