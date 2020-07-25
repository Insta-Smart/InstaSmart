// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instasmart/screens/generate_grid/create_grid_screen.dart';
import 'package:instasmart/screens/help_screen/help_screen.dart';

// Project imports:
import '../HomeScreen.dart';
import '../signup_screen/signup_screen.dart';
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/onboarding_screen/onboarding_end_screen.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:instasmart/utils/size_config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = MyAppState.currentUser;
    SizeConfig().init(context);
    final userRef = Firestore.instance.collection('Users');
    final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();
    print("current user in my app in profile: ${MyAppState.currentUser.uid}");
    //User user = await firebase.currentUser();

    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 18, 0, 0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Hi ${user.firstName}!',
                style: TextStyle(fontSize: 45, color: Constants.palePink),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 7),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        user.firstName == null
                            ? Text("Enter name",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16))
                            : Text(user.firstName + " " + user.lastName,
                                style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(
                            Icons.mode_edit,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditSettings(user),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Email: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(user.email, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        splashColor: Colors.black,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.help_outline),
                            Text("Need Help?", style: TextStyle(fontSize: 16))
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HelpScreen(),
                              ));
                        },
                      ),
                      FlatButton(
                        splashColor: Colors.black,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.black54,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          user.active = false;
                          user.lastOnlineTimestamp = Timestamp.now();
                          //      _fireStoreUtils.updateCurrentUser(user, context);
                          await FirebaseAuth.instance.signOut();
                          MyAppState.currentUser = null;
                          pushAndRemoveUntil(context, AuthScreen(), false);
                        },
                      ),
                    ],
                  )
                ],
              ),
            )

//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(user.uid),
//            ), //for reference only
            ,
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 4),
            ),
            Text("Get In Touch!\n orbital2k20@gmail.com",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class EditSettings extends StatefulWidget {
  final User user;

  EditSettings(@required this.user);

  @override
  _EditSettingsState createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String firstName, lastName, password, confirmPassword;
  bool passwordChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageTopBar(
          title: "Settings",
          appBar: AppBar(),
        ),
        body: Container(
          child: new Form(
              key: _key,
              autovalidate: _validate,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Edit Settings',
                        style: TextStyle(
                            color: Constants.lightPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      )),
                  SignUpTextWidget(
                    context: context,
                    title: "First Name",
                    onSave: (val) {
                      firstName = val;
                    },
                    textObscure: false,
                  ),
                  SignUpTextWidget(
                    context: context,
                    title: "Last Name",
                    onSave: (val) {
                      lastName = val;
                    },
                    textObscure: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, top: 40.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: RaisedButton(
                        color: Constants.lightPurple,
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                        splashColor: Constants.lightPurple,
                        onPressed: () async {
                          await updateServer().then(
                              _showAlertDialog()); //TODO: Error here: Unhandled Exception: type 'Future<void>' is not a subtype of type '(dynamic) => dynamic' of 'f'
                        },
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Constants.lightPurple)),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  updateServer() async {
    _key.currentState.save();
    showProgress(context, 'Updating settings, Please wait...', false);
    //change name
    try {
      final userRef = Firestore.instance.collection('${Constants.USERS}');
      //change name
      print("new name is: ${firstName}");
      await userRef
          .document(widget.user.uid)
          .updateData({"firstName": firstName, "lastName": lastName});
      widget.user.changeFirstName(firstName);
      widget.user.changeLastName(
          lastName); //changing locally so dont have to call firebase
    } catch (e) {
      print("error in updating settings is: ${e}");
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomDialogWidget(
            title: 'Saved!',
            body: 'Changes have been saved',
            DialogCloseRoute: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(index: 4, user: widget.user),
                  ));
            });
      },
    );
  }
}
