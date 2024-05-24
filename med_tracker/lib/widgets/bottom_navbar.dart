import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feedback_outlined),
          label: 'Feedback',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      currentIndex: selectedIndex,
      unselectedItemColor: Colors.black54,
      selectedItemColor: Colors.deepPurple,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/feedback');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/logout');
            break;
        }
      },
      showSelectedLabels: true,
      showUnselectedLabels: false,
    );
  }
}
