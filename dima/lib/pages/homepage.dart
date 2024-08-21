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
            icon:  Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        const FieldListScreen(),
        const AccountScreen(),
      ].elementAt(_selectedIndex),
    );
  }
}