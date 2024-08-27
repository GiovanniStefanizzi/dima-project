import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import '../mocks/field_list/field_list_screen_mock.dart';
import '../mocks/map/map_screen_mock.dart';

void main(){
  testWidgets('map screen buttons test', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);


    await tester.pumpWidget( MaterialApp(home: MapScreenMock()));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    final finder = find.byType(Switch);
    final count = tester.widgetList(finder).length;
    expect(count, 2);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byKey(Key('saveButton')));
  });

  testWidgets('set Polygon and Check', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 432);
  
  
    await tester.pumpWidget( MaterialApp(home: MapScreenMock()));
    await tester.tap(find.byKey(Key('saveButton')));
    var widget = find.byKey(Key('ButtonText'));
    var content= tester.widget<Text>(widget);
    expect(content.data, equals('Save'));
  });
}