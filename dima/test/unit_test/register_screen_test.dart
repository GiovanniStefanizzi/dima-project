import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/login/login_screen_mock.dart';

void main(){
  testWidgets('Register screen tests', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginMock()));
    expect(find.byType(TextButton), findsOneWidget);
    await tester.enterText(find.byKey(const Key('emailfield')), 'prova');
    expect(find.text('prova'), findsOneWidget);
    final finder = find.byType(ElevatedButton);
    final count = tester.widgetList(finder).length;
    expect(count, 2);
    }
  );
}