import 'package:flutter/material.dart';

import '../models/match.dart';

class MatchDetailScreen extends StatelessWidget {
  final Match match;
  const MatchDetailScreen({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEFA),
        title: Text(match.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: '
                '${match.date.year.toString().padLeft(4, '0')}-${match.date.month.toString().padLeft(2, '0')}-${match.date.day.toString().padLeft(2, '0')}'),
            const SizedBox(height: 8),
            Text('Start Time: '
                '${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}'),
            const SizedBox(height: 8),
            Text('Location: ${match.location}'),
            const SizedBox(height: 8),
            Text('Min Players: ${match.minPlayers}'),
            const SizedBox(height: 8),
            Text('Max Players: ${match.capacity}'),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: 'Privacy: ',
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: match.isPrivate ? 'Private' : 'Public',
                    style: TextStyle(
                        color:
                            match.isPrivate ? Colors.red : Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Duration: ${match.duration.inMinutes} minutes'),
            const SizedBox(height: 8),
            Text('Attendees (${match.attendees.length}/${match.capacity}):'),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                children: [
                  ...match.attendees
                      .map((a) => ListTile(title: Text(a)))
                      .toList(),
                  if (match.waitlist.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('Waitlist (${match.waitlist.length}):'),
                    ...match.waitlist
                        .map((w) => ListTile(title: Text(w)))
                        .toList(),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
