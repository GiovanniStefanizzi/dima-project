import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/account/account_screen_mock.dart';

void main(){
  testWidgets('Account screen components testing', (WidgetTester tester) async{

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);

    await tester.pumpWidget(const MaterialApp(home: AccountScreenMock()));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    }
  );


  testWidgets('Account screen dialog testing', (WidgetTester tester) async{

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);

    await tester.pumpWidget(const MaterialApp(home: AccountScreenMock()));
    //press button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    }
  );


  testWidgets('Account screen components testing Tablet', (WidgetTester tester) async{

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);

    await tester.pumpWidget(const MaterialApp(home: AccountScreenMock()));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    }
  );


  testWidgets('Account screen dialog testing Tablet', (WidgetTester tester) async{

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);

    await tester.pumpWidget(const MaterialApp(home: AccountScreenMock()));
    //press button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    }
  );

}