import 'package:flutter_driver/flutter_driver.dart';
import 'package:instasmart/categories.dart';
import 'package:instasmart/test_driver/Keys.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final loginButton = find.byValueKey(Keys.Login);
    final emailField = find.byValueKey(Keys.enterEmail);
    final passwordField = find.byValueKey(Keys.enterPassword);
    final secondLoginButton = find.byValueKey(Keys.secondLogin);
    final counterTextFinder = find.byValueKey(Keys.COUNTER);
    final buttonFinder = find.byValueKey(Keys.increment);
    final iconFinder = find.byValueKey(Keys.iconWidget);
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

//    test('starts at 0', () async {
//      // Use the `driver.getText` method to verify the counter starts at 0.
//      expect(await driver.getText(counterTextFinder), "0");
//    });

    test('increments the number of likes', () async {
      // First, tap the button.
      await driver.clearTimeline();
      await driver.tap(loginButton);
      await driver.tap(emailField);
      await driver.enterText(Keys.email);
      await driver.tap(passwordField);
      await driver.enterText(Keys.password);
      await driver.tap(secondLoginButton);
      await driver.tap(find.byValueKey(Categories.landscape));
      String origNumLikes = await driver.getText(counterTextFinder);

      Future<bool> isLiked() async {
        //only liked heart icon has this key. if not found, heart is not yet liked.
        try {
          await driver.waitFor(iconFinder, timeout: Duration(seconds: 30));
          return true;
        } catch (exception) {
          return false;
        }
      }

      String expectedNumLikes;
      await isLiked().then((value) {
        expectedNumLikes = value
            ? (int.parse(origNumLikes) - 1).toString()
            : (int.parse(origNumLikes) + 1).toString();
      });
      await driver.tap(buttonFinder);
      // Then, verify the counter text is incremented by 1.
      expect(await driver.getText(counterTextFinder), expectedNumLikes);

      //TODO: change 8 to driver.getText();
      //TODO: make it switch category
      //TODO: make it unlike also
    },
        timeout: Timeout(
          Duration(minutes: 5),
        ));
  });
}
