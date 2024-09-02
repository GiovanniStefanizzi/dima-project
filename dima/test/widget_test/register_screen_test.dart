import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/login/login_screen_mock.dart';
import '../mocks/register/register_screen_mock.dart';

void main(){
  testWidgets('Register screen tests', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);

    await tester.pumpWidget(const MaterialApp(home: RegisterMock()));
    expect(find.byType(TextButton), findsOneWidget);
    await tester.enterText(find.byKey(const Key('email')), 'prova');
    expect(find.text('prova'), findsOneWidget);
    final finder = find.byType(ElevatedButton);
    final count = tester.widgetList(finder).length;
    expect(count, 2);
    final textFieldFinder = find.byType(TextField);
    final textFieldCount = tester.widgetList(textFieldFinder).length;
    expect(textFieldCount, 4);
    }
  );

  //TABLET

  testWidgets('Register screen tests tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
    
    await tester.pumpWidget(const MaterialApp(home: RegisterMock()));
    expect(find.byType(TextButton), findsOneWidget);
    await tester.enterText(find.byKey(const Key('email')), 'prova');
    expect(find.text('prova'), findsOneWidget);
    final finder = find.byType(ElevatedButton);
    final count = tester.widgetList(finder).length;
    expect(count, 2);
    }
  );
}