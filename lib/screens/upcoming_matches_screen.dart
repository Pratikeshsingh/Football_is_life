import 'package:flutter/material.dart';

import '../models/match.dart';
import '../models/user.dart';
import 'match_detail_screen.dart';

class UpcomingMatchesScreen extends StatefulWidget {
  final User user;
  const UpcomingMatchesScreen({Key? key, required this.user}) : super(key: key);

  static final List<Match> matches = [
    Match(
      id: '1',
      title: 'Friendly Kickoff',
      date: DateTime.now().add(const Duration(days: 1)),
      location: 'Local Stadium',
      capacity: 50,
      attendees: ['Sam', 'Kim', 'Alex'],
    ),
    Match(
      id: '2',
      title: 'Championship Qualifier',
      date: DateTime.now().add(const Duration(days: 2)),
      location: 'City Arena',
      capacity: 100,
      attendees: ['Jordan'],
    ),
    Match(
      id: '3',
      title: 'Season Finale',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'Grand Arena',
      capacity: 1000,
      attendees: ['Dana', 'Lee'],
    ),
    Match(
      id: '4',
      title: 'Morning Practice',
      date: DateTime.now().add(const Duration(days: 3)),
      location: 'Community Field',
      capacity: 20,
      attendees: ['Morgan', 'Jess'],
    ),
    Match(
      id: '5',
      title: 'Charity Cup',
      date: DateTime.now().add(const Duration(days: 4)),
      location: 'Downtown Pitch',
      capacity: 30,
      attendees: ['Luis', 'Tim', 'Hana'],
    ),
    Match(
      id: '6',
      title: 'Neighborhood League',
      date: DateTime.now().add(const Duration(days: 5)),
      location: 'Westside Grounds',
      capacity: 40,
      attendees: ['Ariel'],
    ),
  ];

  @override
  State<UpcomingMatchesScreen> createState() => _UpcomingMatchesScreenState();
}

class _UpcomingMatchesScreenState extends State<UpcomingMatchesScreen> {
  void _joinMatch(Match match) {
    setState(() {
      if (!match.attendees.contains(widget.user.name)) {
        match.attendees.add(widget.user.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = UpcomingMatchesScreen.matches
        .where((m) => m.date.isAfter(DateTime.now()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF58CC02),
        title: const Text('Upcoming Matches'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${widget.user.name}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Joined on: ${widget.user.joinDate.toLocal().toString().split(' ')[0]}',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: upcoming.length,
              itemBuilder: (context, index) {
                final match = upcoming[index];
                return Card(
                  color: const Color(0xFFCFF3A8),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      match.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${match.date.toLocal()}'.split(' ')[0] +
                          ' | Players: ${match.attendees.length}/${match.capacity}',
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _joinMatch(match),
                      child: const Text('Join'),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MatchDetailScreen(match: match),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

