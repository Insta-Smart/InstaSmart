import 'package:test/test.dart';
import 'package:instasmart/services/login_functions.dart';


void main() {
  test('Email Validation', () {

    final valid = Validation.validateEmail('testemail@gmail.com');
    expect(valid, true);
  });
}