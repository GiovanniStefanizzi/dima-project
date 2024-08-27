import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/account/account_screen_mock.dart';

void main(){
  testWidgets('Account screen components testing', (WidgetTester tester) async{

    await tester.pumpWidget(const MaterialApp(home: AccountScreenMock()));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    }
  );


  testWidgets('Account screen components testing', (WidgetTester tester) async{

    await tester.pumpWidget(const MaterialApp(home: AccountScreenMock()));
    //press button
    await tester.tap(find.byKey(Key('change_username_button')).first);
    expect(find.byType(TextField), findsOneWidget);
    }
  );
}