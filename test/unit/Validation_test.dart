//import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/services/Validation.dart';


void main() {
  test('Email Validation', () {

    var resu = Validation.validateEmail('testemail@gmail.com');
    expect(resu, true);
  });

  test('Password Validation', () {

    var resu = Validation.validatePassword('123456');
    expect(resu, false);
  });

}