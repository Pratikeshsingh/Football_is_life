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
      minPlayers: 8,
      capacity: 12,
      isPrivate: false,
      attendees: ['Sam', 'Kim', 'Alex'],
    ),
    Match(
      id: '2',
      title: 'Championship Qualifier',
      date: DateTime.now().add(const Duration(days: 2)),
      location: 'City Arena',
      minPlayers: 8,
      capacity: 16,
      isPrivate: true,
      attendees: ['Jordan'],
    ),
    Match(
      id: '3',
      title: 'Season Finale',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'Grand Arena',
      minPlayers: 10,
      capacity: 15,
      isPrivate: false,
      attendees: ['Dana', 'Lee'],
    ),
    Match(
      id: '4',
      title: 'Morning Practice',
      date: DateTime.now().add(const Duration(days: 3)),
      location: 'Community Field',
      minPlayers: 6,
      capacity: 10,
      isPrivate: false,
      attendees: ['Morgan', 'Jess'],
    ),
    Match(
      id: '5',
      title: 'Charity Cup',
      date: DateTime.now().add(const Duration(days: 4)),
      location: 'Downtown Pitch',
      minPlayers: 8,
      capacity: 14,
      isPrivate: true,
      attendees: ['Luis', 'Tim', 'Hana'],
    ),
    Match(
      id: '6',
      title: 'Neighborhood League',
      date: DateTime.now().add(const Duration(days: 5)),
      location: 'Westside Grounds',
      minPlayers: 8,
      capacity: 13,
      isPrivate: false,
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

  void _showCreateMatchDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final locationController = TextEditingController();
    final minController = TextEditingController();
    final maxController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Start a Game'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        labelText: 'Date (YYYY-MM-DD HH:MM)'),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  TextField(
                    controller: minController,
                    decoration:
                        const InputDecoration(labelText: 'Min Players'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxController,
                    decoration: const InputDecoration(
                        labelText: 'Max Players (10-16)'),
                    keyboardType: TextInputType.number,
                  ),
                  SwitchListTile(
                    title: const Text('Private'),
                    value: isPrivate,
                    onChanged: (val) {
                      setStateDialog(() {
                        isPrivate = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final maxPlayers = int.tryParse(maxController.text) ?? 0;
                  if (maxPlayers < 10 || maxPlayers > 16) {
                    return;
                  }
                  final minPlayers = int.tryParse(minController.text) ?? 0;
                  final dateInput = dateController.text;
                  final date =
                      DateTime.tryParse(dateInput.replaceFirst(' ', 'T')) ??
                          DateTime.now();
                  final match = Match(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    date: date,
                    location: locationController.text,
                    minPlayers: minPlayers,
                    capacity: maxPlayers,
                    isPrivate: isPrivate,
                    attendees: [],
                  );
                  setState(() {
                    UpcomingMatchesScreen.matches.add(match);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = UpcomingMatchesScreen.matches
        .where((m) => m.date.isAfter(DateTime.now()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEFA),
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
                  color: const Color(0xFFE1F5FE),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      match.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${match.date.toLocal()}'.split('.').first +
                            ' @ ${match.location}\n'
                            'Players: ${match.attendees.length}/${match.capacity} | '
                            '${match.isPrivate ? 'Private' : 'Public'}'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87CEFA),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _joinMatch(match),
                      child:
                          Text(match.isPrivate ? 'Join Waitlist' : 'Join'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateMatchDialog,
        backgroundColor: const Color(0xFF87CEFA),
        foregroundColor: Colors.white,
        label: const Text('Start Game'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

