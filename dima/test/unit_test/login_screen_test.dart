import 'package:dima/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dima/main.dart';
import 'package:mockito/mockito.dart';

import '../mocks/login/login_screen_mock.dart';
import '../mocks/register/register_screen_mock.dart';

//create a test for the login screen
 void main() {
   //test on login screen mock
  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginMock()));

    // Verify that the signup screen is displayed
    expect(find.byType(TextButton), findsOneWidget);
    //try to write in the email field and check if correctly written
    await tester.enterText(find.byKey(Key('emailfield')),'prova');
    expect(find.text('prova'), findsOneWidget);
    //presso on signupbutton and test if it works
    await tester.tap(find.byKey(Key('signupbutton')));

    
  });
 }