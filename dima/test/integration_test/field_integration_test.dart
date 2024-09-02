import 'dart:math';
import 'dart:ui';

import 'package:dima/pages/field_details/meteo_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/field_details/meteo_details_mock.dart';
import '../mocks/field_list/field_list_screen_mock.dart';

void main(){
  testWidgets('check a field from the list, look at detail', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(MaterialApp(home: FieldListScreenMock()));

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byKey(Key('image')), findsOneWidget);
    
    await tester.ensureVisible(find.byType(ListTile));
    //get the name from the listtile

    String? fieldName = tester.widget<Text>(find.byType(Text).first).data;
    
    //print('fieldName: $fieldName');

    await tester.tap(find.byType(ListTile));

    await tester.pumpAndSettle();

    expect(find.byKey(Key('nameOfField')), findsOneWidget);
    //get the name from the detail screen
    String? fieldNameDetail = tester.widget<Text>(find.byKey(Key('nameOfField'))).data;

    expect(fieldName, fieldNameDetail);

    //check meteo
    expect(find.byKey(Key('meteo details')), findsOneWidget);

    //check scroll and activities
    await tester.drag(find.byKey(Key('pageView')), const Offset(-300, 0.0));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('addActivity')), findsOneWidget);
  
    await tester.tap(find.byKey(Key('addActivity')));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    //press on cancel
    await tester.tap(find.byKey(Key('cancel')));
    await tester.pumpAndSettle();

    //check if it is still on the same page of the screen
    expect(find.byKey(Key('addActivity')), findsOneWidget);


    //check scroll types of overlays
    await tester.drag(find.byKey(Key('pageView')), const Offset(-300, 0.0));
    await tester.pumpAndSettle();

    //check fort the text ndvi
    expect(find.text('NDVI'), findsOneWidget);
    
  });
}