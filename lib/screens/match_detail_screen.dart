import 'package:flutter/material.dart';

import '../models/match.dart';

class MatchDetailScreen extends StatelessWidget {
  final Match match;
  final List<Match> allMatches;
  const MatchDetailScreen({Key? key, required this.match, required this.allMatches}) : super(key: key);

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    if (match.isPrivate) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF87CEFA),
          title: Text(match.title),
        ),
        body: const Center(
          child: Text('This match is private. Details are hidden.'),
        ),
      );
    }

    final dayName = _weekdays[match.date.weekday - 1];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEFA),
        title: Text(match.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a?auto=format&fit=crop&w=800&q=80'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black38,
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Date: $dayName ${match.date.year.toString().padLeft(4, '0')}-${match.date.month.toString().padLeft(2, '0')}-${match.date.day.toString().padLeft(2, '0')}'),
              const SizedBox(height: 8),
              Text(
                  'Start Time: ${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}'),
              const SizedBox(height: 8),
              Text('Location: ${match.venue}'),
              const SizedBox(height: 8),
              Text('Min Players: ${match.minPlayers}'),
              const SizedBox(height: 8),
              Text('Max Players: ${match.capacity}'),
              const SizedBox(height: 8),
              Text('Duration: ${match.duration.inMinutes} minutes'),
              const SizedBox(height: 8),
              Text('Attendees (${match.attendees.length}/${match.capacity}):'),
              const SizedBox(height: 4),
              Expanded(
                child: ListView(
                  children: [
                    ...match.attendees.map((a) => Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(child: Text(a[0])),
                              title: Text(a),
                              onTap: () => _showPlayerDialog(context, a),
                            ),
                            const Divider(),
                          ],
                        )),
                    if (match.waitlist.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Waitlist (${match.waitlist.length}):'),
                      ...match.waitlist.map((w) => Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(child: Text(w[0])),
                                title: Text(w),
                                onTap: () => _showPlayerDialog(context, w),
                              ),
                              const Divider(),
                            ],
                          )),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlayerDialog(BuildContext context, String name) {
    final joinCount =
        allMatches.where((m) => m.attendees.contains(name)).length;
    final leagues = allMatches
        .where((m) => !m.isPrivate && m.attendees.contains(name))
        .map((m) => m.title)
        .toSet()
        .toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 30, child: Text(name[0])),
            const SizedBox(height: 8),
            Text('Joined $joinCount times'),
            if (leagues.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Plays with:'),
              for (final l in leagues) Text(l),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }
}

