import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/models/user.dart';
import '../mock_services/mock_login_functions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Email Validation', () {
    test('email should have `@` symbol', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validateEmail('testemailgmail.com');
      expect(isValid, false);
    });
    test('email should have `.` symbol', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validateEmail('testemail@gmailcom');
      expect(isValid, false);
    });

    test('email should have text before `@` symbol', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validateEmail('@gmail.com');
      expect(isValid, false);
    });

    test('valid regular email', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validateEmail('testemail@yahoo.co.uk');
      expect(isValid, true);
    });

    test('valid email with number', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validateEmail('test123email@u.nus.edu');
      expect(isValid, true);
    });
  });

  group('Password Validation', () {
    test('password should have atleast 8 characters', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validatePassword('1234567');
      expect(isValid, false);
    });

    test('password should have atleast 1 number', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validatePassword('cnjefvevnef');
      expect(isValid, false);
    });

    test('password should have atleast 1 Uppercase letter', () {
      final login = MockFireBaseLoginFunctions();
      bool isValid = login.validatePassword('123abcsded');
      expect(isValid, false);
    });

    test(
        'password should have atleast 1 Uppercase letter, 1 number and 8 characters',
        () {
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
