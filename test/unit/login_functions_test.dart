import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:instasmart/models/user.dart';
import '../mock_services/mock_login_functions.dart';
=======
import 'package:instasmart/services/login_functions.dart';

>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Email Validation', () {
    test('email should have `@` symbol', () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
=======
      final login = FirebaseLoginFunctions();
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      bool isValid = login.validateEmail('testemailgmail.com');
      expect(isValid, false);
    });
    test('email should have `.` symbol', () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
=======
      final login = FirebaseLoginFunctions();
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      bool isValid = login.validateEmail('testemail@gmailcom');
      expect(isValid, false);
    });

<<<<<<< HEAD
    test('email should have text before `@` symbol', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validateEmail('@gmail.com');
=======
    test('email should have `.` symbol', () {
      final login = FirebaseLoginFunctions();
      bool isValid = login.validateEmail('testemail@gmailcom');
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      expect(isValid, false);
    });

    test('valid regular email', () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
=======
      final login = FirebaseLoginFunctions();
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      bool isValid = login.validateEmail('testemail@yahoo.co.uk');
      expect(isValid, true);
    });

    test('valid email with number', () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
=======
      final login = FirebaseLoginFunctions();
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      bool isValid = login.validateEmail('test123email@u.nus.edu');
      expect(isValid, true);
    });
  });

  group('Password Validation', () {
    test('password should have atleast 8 characters', () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
=======
      final login = FirebaseLoginFunctions();
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      bool isValid = login.validatePassword('1234567');
      expect(isValid, false);
    });

    test('password should have atleast 1 number', () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
=======
      final login = FirebaseLoginFunctions();
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      bool isValid = login.validatePassword('cnjefvevnef');
      expect(isValid, false);
    });

    test('password should have atleast 1 Uppercase letter', () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
=======
      final login = FirebaseLoginFunctions();
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
      bool isValid = login.validatePassword('123abcsded');
      expect(isValid, false);
    });

    test(
        'password should have atleast 1 Uppercase letter, 1 number and 8 characters',
        () {
<<<<<<< HEAD
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validatePassword('1234567Q');
      expect(isValid, true);
    });

    test(
        'sign in with email and password',
            () async {

              final login = MockFireBaseLoginFunctions();
              var user = await login.signInWithEmailAndPassword('test@gmail.com', '1234567Q');
             expect(user, isA<User>());
        });

    test(
        'sign in with email and password',
            () async {

          final login = MockFireBaseLoginFunctions();
          var user = await login.signInWithEmailAndPassword('test@gmail.com', '1234567Q');
          expect(user, isA<User>());
        });
  });
}
=======
      final login = FirebaseLoginFunctions();
      bool isValid = login.validatePassword('1234567Q');
      expect(isValid, true);
    });
  });
}


>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
