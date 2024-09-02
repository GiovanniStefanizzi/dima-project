import 'dart:math';

import 'package:dima/firebase_options.dart';
import 'package:dima/pages/homepage.dart';
import 'package:dima/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:integration_test/integration_test.dart';

import 'package:dima/main.dart' as app;

import '../mocks/login/login_screen_mock.dart';

void main(){
  testWidgets('register, login and logout', (tester) async{
    
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: LoginMock()));
       
    expect(find.byKey(Key('signupbutton')), findsOneWidget);
    await tester.tap(find.byKey(Key('signupbutton')));
    await tester.pumpAndSettle();

    //check the page changed
    expect(find.byKey(Key('register')), findsOneWidget);

    await tester.enterText(find.byKey(Key('username')), 'test');
    await tester.enterText(find.byKey(Key('email')), 'test@testing.it');
    await tester.enterText(find.byKey(Key('password')), '12345');
    await tester.enterText(find.byKey(Key('repeatPassword')), '12345');
    
    //check validator of text form field    
    await tester.tap(find.byKey(Key('registerbutton')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('register')), findsOneWidget);

    await tester.enterText(find.byKey(Key('password')), '12345678');
    await tester.enterText(find.byKey(Key('repeatPassword')), '12345678');
    await tester.tap(find.byKey(Key('registerbutton')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('accountPage')), findsOneWidget);

    //open the account page
    await tester.tap(find.byKey(Key('accountPage')));
    await tester.pumpAndSettle();

    //logout
    expect(find.byKey(Key('logoutButton')), findsOneWidget);
    await tester.tap(find.byKey(Key('logoutButton')));
    await tester.pumpAndSettle();

    //check the page changed
    expect(find.byKey(Key('signupbutton')), findsOneWidget);

    
  });
}