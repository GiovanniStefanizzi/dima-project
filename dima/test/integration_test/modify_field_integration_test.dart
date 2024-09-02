import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/field_details/field_details_screen_mock.dart';

void main(){
  testWidgets('check a field from the list, look at detail', (WidgetTester tester) async {
  
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(MaterialApp(home: FieldDetailsScreenMock()));


    //check the delete button and then cancel
    expect(find.byKey(Key('deleteButton')), findsOneWidget);
    await tester.tap(find.byKey(Key('deleteButton')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.byKey(Key('cancel')));
    await tester.pumpAndSettle();


    //get name of the field 
    
  

    Text appBarText = find.byKey(Key('nameOfField')).evaluate().single.widget as Text;
    final nameOfField=appBarText.data;
    print(nameOfField);
    
    //delete button and then confirm

    await tester.tap(find.byKey(Key('deleteButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('delete')));
    await tester.pumpAndSettle();

    //check if it returnet to home page
    expect(find.byType(ListTile), findsOneWidget);

    //open field
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    //check modify button
    expect(find.byKey(Key('modifyButton')), findsOneWidget);
    await tester.tap(find.byKey(Key('modifyButton')));
    await tester.pumpAndSettle();

    //check if it is on the modify screen
    expect(find.byKey(Key('modifyFieldScreen')), findsOneWidget);

    //get the name of the field from the Key('fieldName') Textfield
    final TextField widget = find.byKey(Key('fieldName')).evaluate().single.widget as TextField;
    final nameField = widget.controller!.text;
    print(nameField);
    //check if the text is the same as the one we expect
    expect(nameField, nameOfField);
    
  });
}