import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navshell;

  const AppBottomNavBar({super.key, required this.navshell});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navshell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navshell.currentIndex,
        onDestinationSelected: (index) {
          navshell.goBranch(
            index,
            initialLocation: index == navshell.currentIndex
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.computer), label: 'Builder'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}