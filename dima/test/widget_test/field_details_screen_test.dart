import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/main.dart';
import 'package:dima/pages/field_details/maps_overlay.dart';
import 'package:dima/pages/field_details/meteo_details.dart';
import 'package:dima/pages/field_details/modify_field_screen.dart';
import 'package:dima/utils/map_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/account/account_screen_mock.dart';
import '../mocks/field_details/activity_mock.dart';
import '../mocks/field_details/field_details_screen_mock.dart';
import '../mocks/field_details/meteo_details_mock.dart';
import '../mocks/field_details/modify_screen_mock.dart';


void main(){
  testWidgets('  has appBar', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    expect(find.text('name'), findsOneWidget);
  });

  testWidgets('FieldDetailsScreen space for map', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    expect(find.byType(Placeholder), findsOneWidget);
  });
  testWidgets('FieldDetailsScreen multiple pages', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(Key('pageView')), const Offset(-300, 0.0));
    await tester.pumpAndSettle();
    await tester.drag(find.byKey(Key('pageView')), const Offset(-300, 0.0));
    await tester.pumpAndSettle();
    //find pageview and get the current page
    final pageView = tester.widget<PageView>(find.byKey(Key('pageView')));
    expect(pageView.controller?.page, 2);

  });
  

  testWidgets('FieldDetailsScreen meteoWidget', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    expect(find.byType(MeteoDetailsWidgetMock), findsOneWidget);
    
    //check if there are 6 images
    expect(find.byType(Image), findsNWidgets(6));

  });

  testWidgets('FieldDetailsScreen activityWidget', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(Key('pageView')), const Offset(-300, 0.0));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityWidgetMock), findsOneWidget);
    
    //click on the button
    await tester.tap(find.byKey(Key('addActivity')));

  });

  testWidgets('FieldDetailsScreen overlayWidget', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(Key('pageView')), const Offset(-300, 0.0));
    await tester.pumpAndSettle();
    await tester.drag(find.byKey(Key('pageView')), const Offset(-300, 0.0));
    await tester.pumpAndSettle();

    expect(find.byType(MapsOverlayPage), findsOneWidget);
    
    //click on the button
    expect(find.byType(Radio<MapOverlayType>), findsNWidgets(6));

  });

  testWidgets('FieldDetailsScreen has delete button', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    //tap on the delete button
    await tester.tap(find.byKey(Key('deleteButton')));
    await tester.pumpAndSettle();
    //check for alert dialog
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('FieldDetailsScreen has modify  button', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    //tap on the delete button
    await tester.tap(find.byKey(Key('modifyButton')));
    await tester.pumpAndSettle();
  });





  /// TABLET TESTS



  testWidgets('FieldDetailsScreen has appBar tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    expect(find.text('name'), findsOneWidget);
  });

  testWidgets('FieldDetailsScreen space for map Tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    expect(find.byType(Placeholder), findsOneWidget);
  });
  testWidgets('FieldDetailsScreen multiple pages Tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(Key('pageView')), const Offset(-600, 0.0));
    await tester.pumpAndSettle();
    await tester.drag(find.byKey(Key('pageView')), const Offset(-600, 0.0));
    await tester.pumpAndSettle();
    //find pageview and get the current page
    final pageView = tester.widget<PageView>(find.byKey(Key('pageView')));
    expect(pageView.controller?.page, 2);

  });
  

  testWidgets('FieldDetailsScreen meteoWidget tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    expect(find.byType(MeteoDetailsWidgetMock), findsOneWidget);
    
    //check if there are 6 images
    expect(find.byType(Image), findsNWidgets(6));

  });

  testWidgets('FieldDetailsScreen activityWidget tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(Key('pageView')), const Offset(-600, 0.0));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityWidgetMock), findsOneWidget);
    
    //click on the button
    await tester.tap(find.byKey(Key('addActivity')));

  });

  testWidgets('FieldDetailsScreen overlayWidget tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(Key('pageView')), const Offset(-600, 0.0));
    await tester.pumpAndSettle();
    await tester.drag(find.byKey(Key('pageView')), const Offset(-600, 0.0));
    await tester.pumpAndSettle();

    expect(find.byType(MapsOverlayPage), findsOneWidget);
    
    //click on the button
    expect(find.byType(Radio<MapOverlayType>), findsNWidgets(6));

  });

  testWidgets('FieldDetailsScreen has delete button tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    //tap on the delete button
    await tester.tap(find.byKey(Key('deleteButton')));
    await tester.pumpAndSettle();
    //check for alert dialog
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('FieldDetailsScreen has modify button tablet', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1600, 2560);
  
    await tester.pumpWidget(const MaterialApp(home: FieldDetailsScreenMock()));
    await tester.pumpAndSettle();

    //tap on the delete button
    await tester.tap(find.byKey(Key('modifyButton')));
    await tester.pumpAndSettle();
    
  });
}
