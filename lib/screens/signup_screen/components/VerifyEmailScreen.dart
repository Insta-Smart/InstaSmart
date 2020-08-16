// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/login_screen/login_screen.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:instasmart/utils/size_config.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;
  const VerifyEmailScreen({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset(
                            'assets/images/instasmart_logo_final.png',
                            height: 150,
                          ),
                        ),
                        Text(
                          "We have sent you a verification email! Please verify & proceed to login to the app.",
                          style: TextStyle(
                            color: Constants.lightPurple,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'hi',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 17.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 40.0, left: 40.0, bottom: 20),
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(minWidth: double.infinity),
                            child: RaisedButton(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              color: Constants.lightPurple,
                              textColor: Constants.lightPurple,
                              splashColor: Constants.paleBlue,
                              onPressed: () async {
                                pushAndRemoveUntil(
                                    context, LoginScreen(), false);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side:
                                      BorderSide(color: Constants.lightPurple)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
