import 'package:flutter/material.dart';

import '../models/user.dart';
import 'upcoming_matches_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _WelcomeTab(user: widget.user),
      const _LeaguesTab(),
      UpcomingMatchesScreen(user: widget.user),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Leagues'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Games'),
        ],
      ),
    );
  }
}

class _WelcomeTab extends StatelessWidget {
  final User user;
  const _WelcomeTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text(
          'Welcome, ${user.name}!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class _LeaguesTab extends StatelessWidget {
  const _LeaguesTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Leagues')),
      body: const Center(
        child: const Text('No leagues yet'),
      ),
    );
  }
}

