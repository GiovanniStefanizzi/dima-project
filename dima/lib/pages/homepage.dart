import 'package:dima/pages/account/account_screen.dart';
import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.agriculture),
            label: 'Fields',
          ),
          NavigationDestination(
            icon:  Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        FieldListScreen(),
        AccountScreen(),
      ].elementAt(_selectedIndex),
    );
  }
}