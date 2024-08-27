import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/field_list/field_list_screen_mock.dart';
import '../mocks/login/login_screen_mock.dart';

void main(){
  testWidgets('field list button test', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);


    await tester.pumpWidget(const MaterialApp(home: FieldListScreenMock()));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    

  });
  testWidgets('field list listTile test', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);


    await tester.pumpWidget(const MaterialApp(home: FieldListScreenMock()));
    //get text with key temperature and check if it is 10°
    var widget = find.byKey(Key('temperature'));

    final textWidget = tester.widget<Text>(widget);
    final textValue = textWidget.data;

    // Verifica che il testo sia uguale a "10°C"
    expect(textValue, equals('10°C'));
     
     var imageWidget = find.byKey(Key('image'));
     final image = tester.widget<Image>(imageWidget);
     expect(image.image, AssetImage('assets/images/2.png'));
  });
}