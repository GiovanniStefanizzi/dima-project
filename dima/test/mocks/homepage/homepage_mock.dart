import 'package:dima/pages/account/account_screen.dart';
import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../account/account_screen_mock.dart';
import '../field_list/field_list_screen_mock.dart';

class HomepageMock extends StatefulWidget {
  const HomepageMock({super.key});

  @override
  State<HomepageMock> createState() => _HomepageState();
}

class _HomepageState extends State<HomepageMock> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 153, 194, 162),
        backgroundColor: const Color.fromARGB(255, 219, 254, 184),
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.agriculture),
            label: 'Fields',
          ),
          NavigationDestination(
            key: Key('accountPage'),
            icon:  Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        const FieldListScreenMock(),
        const AccountScreenMock(),
      ].elementAt(_selectedIndex),
    );
  }
}