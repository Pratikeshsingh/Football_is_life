import 'package:flutter/material.dart';

import '../models/match.dart';

class MatchDetailScreen extends StatelessWidget {
  final Match match;
  const MatchDetailScreen({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(match.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ' + '${match.date.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 8),
            Text('Location: ${match.location}'),
            const SizedBox(height: 8),
            Text('Capacity: ${match.capacity}'),
            const SizedBox(height: 8),
            Text('Attendees (${match.attendees.length}/${match.capacity}):'),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                itemCount: match.attendees.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(match.attendees[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
