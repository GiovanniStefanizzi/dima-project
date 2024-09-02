import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/login/login_screen_mock.dart';
import '../mocks/map/map_screen_mock.dart';

void main (){
  testWidgets('add field screen to list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget( MaterialApp(home: MapScreenMock()));

    expect(find.byKey(Key('saveButton')), findsOneWidget);
   
    //write field name
    await tester.enterText(find.byKey(Key('fieldName')), 'test');
    //write crop 
    await tester.enterText(find.byKey(Key('cropType')), 'test');
    //set notifications
    await tester.tap(find.byKey(Key('frost')));
    await tester.tap(find.byKey(Key('hail')));


    expect(find.byKey(Key('saveButton')), findsOneWidget);
    //save field
    await tester.ensureVisible(find.byKey(Key('saveButton')));
    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();
    //check if it returnet to home page
    expect(find.byKey(Key('accountPage')), findsOneWidget);
    
    });
}