import 'package:flutter/material.dart';

import '../models/match.dart';
import '../models/user.dart';
import 'match_detail_screen.dart';

class UpcomingMatchesScreen extends StatelessWidget {
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
      date: DateTime.now().subtract(const Duration(days: 1)),
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
  ];

  @override
  Widget build(BuildContext context) {
    final upcoming =
        matches.where((m) => m.date.isAfter(DateTime.now())).toList();
    return Scaffold(
      appBar: AppBar(
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
                  'Welcome, ${user.name}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Joined on: ${user.joinDate.toLocal().toString().split(' ')[0]}',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: upcoming.length,
              itemBuilder: (context, index) {
                final match = upcoming[index];
                return ListTile(
                  title: Text(match.title),
                  subtitle: Text('${match.date.toLocal()}'.split(' ')[0]),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MatchDetailScreen(match: match),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
