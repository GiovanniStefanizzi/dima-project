import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/field_details/modify_screen_mock.dart';

void main(){
  testWidgets('Modify screen test', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);

    await tester.pumpWidget(const MaterialApp(home: ModifyFieldScreenMock()));
    expect(find.byType(ElevatedButton), findsOneWidget);
    }
  );
  testWidgets('previous values presence', (WidgetTester tester) async{
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);

    await tester.pumpWidget(const MaterialApp(home: ModifyFieldScreenMock()));
     
    var widget = find.byKey(Key('date')).evaluate().first.widget as TextField;
    
    //extract the text from the widget
    final text = widget.controller!.text;
    
    //check if the text is the same as the one we expect
    expect(text, equals('2024-08-14'));
    } 
  );


  //TABLET


  testWidgets('Modify screen test tablet', (WidgetTester tester) async {

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
    
    await tester.pumpWidget(const MaterialApp(home: ModifyFieldScreenMock()));
    expect(find.byType(ElevatedButton), findsOneWidget);
    }
  );


  testWidgets('previous values presence tablet', (WidgetTester tester) async{

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);

    await tester.pumpWidget(const MaterialApp(home: ModifyFieldScreenMock()));
     
    var widget = find.byKey(Key('date')).evaluate().first.widget as TextField;
    
    //extract the text from the widget
    final text = widget.controller!.text;
    
    //check if the text is the same as the one we expect
    expect(text, equals('2024-08-14'));
    } 
  );
}