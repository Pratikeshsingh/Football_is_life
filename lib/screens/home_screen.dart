import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/match.dart';
import 'upcoming_matches_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _status = 'Available';

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _WelcomeTab(
        user: widget.user,
        status: _status,
        onStatusChanged: (val) => setState(() => _status = val),
      ),
      _LeaguesTab(user: widget.user),
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
  final String status;
  final ValueChanged<String> onStatusChanged;
  const _WelcomeTab({required this.user, required this.status, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    final monthsActive = DateTime.now().difference(user.joinDate).inDays ~/ 30;
    final myMatches = UpcomingMatchesScreen.matches
        .where((m) => m.attendees.contains(user.name))
        .toList();
    final upcoming = myMatches.where((m) => m.isUpcoming).take(3).toList();
    final past = myMatches.where((m) => !m.isUpcoming).take(3).toList();

    Widget buildMatchTile(Match match) {
      final date = match.date;
      final dateStr =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return ListTile(
        leading: const Icon(Icons.sports_soccer),
        title: Text(match.title),
        subtitle: Text('$dateStr @ ${match.location}'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Welcome, ${user.name}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Phone: ${user.phone}'),
            Text('Member for $monthsActive months'),
            Row(
              children: [
                const Text('Status:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: status,
                  items: const [
                    DropdownMenuItem(value: 'Available', child: Text('Available')),
                    DropdownMenuItem(value: 'Injured', child: Text('Injured')),
                    DropdownMenuItem(value: 'On Vacation', child: Text('On Vacation')),
                  ],
                  onChanged: onStatusChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Upcoming Games'),
            if (upcoming.isEmpty)
              const Text('None')
            else
              ...upcoming.map(buildMatchTile),
            const SizedBox(height: 16),
            const Text('Recent Games'),
            if (past.isEmpty)
              const Text('None')
            else
              ...past.map(buildMatchTile),
          ],
        ),
      ),
    );
  }
}

class _LeaguesTab extends StatelessWidget {
  final User user;
  const _LeaguesTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final myMatches = UpcomingMatchesScreen.matches
        .where((m) => m.attendees.contains(user.name))
        .toList();
    final upcoming = myMatches.where((m) => m.isUpcoming).toList();
    final past = myMatches.where((m) => !m.isUpcoming).toList();
    final display = upcoming.isNotEmpty ? upcoming : past;

    if (display.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Leagues')),
        body: const Center(child: Text('No leagues yet')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Leagues')),
      body: ListView(
        children: [
          for (final m in display)
            ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: Text(m.title),
              subtitle: Text(
                  '${m.date.year.toString().padLeft(4, '0')}-${m.date.month.toString().padLeft(2, '0')}-${m.date.day.toString().padLeft(2, '0')} @ ${m.location}'),
            ),
        ],
      ),
    );
  }
}

