import 'package:flutter/material.dart';

import '../models/match.dart';
import '../models/user.dart';
import 'match_detail_screen.dart';

class UpcomingMatchesScreen extends StatefulWidget {
  final User user;
  const UpcomingMatchesScreen({Key? key, required this.user}) : super(key: key);

  static final DateTime _now = DateTime.now();
  static final List<Match> matches = [
    Match(
      id: '1',
      title: 'Friendly Kickoff',
      date: DateTime(_now.year, _now.month, _now.day + 1, 10, 0),
      location: 'Alkmaar',
      minPlayers: 8,
      capacity: 12,
      isPrivate: false,
      attendees: ['Sam', 'Kim', 'Alex'],
      waitlist: [],
      duration: const Duration(minutes: 90),
    ),
    Match(
      id: '2',
      title: 'Championship Qualifier',
      date: DateTime(_now.year, _now.month, _now.day + 2, 11, 15),
      location: 'Heiloo',
      minPlayers: 8,
      capacity: 16,
      isPrivate: true,
      attendees: ['Jordan'],
      waitlist: [],
      duration: const Duration(minutes: 90),
    ),
    Match(
      id: '3',
      title: 'Season Finale',
      date: DateTime(_now.year, _now.month, _now.day + 7, 14, 30),
      location: 'Castricum',
      minPlayers: 10,
      capacity: 15,
      isPrivate: false,
      attendees: ['Dana', 'Lee'],
      waitlist: [],
      duration: const Duration(minutes: 120),
    ),
    Match(
      id: '4',
      title: 'Morning Practice',
      date: DateTime(_now.year, _now.month, _now.day + 3, 9, 0),
      location: 'Amsterdam',
      minPlayers: 6,
      capacity: 10,
      isPrivate: false,
      attendees: ['Morgan', 'Jess'],
      waitlist: [],
      duration: const Duration(minutes: 60),
    ),
    Match(
      id: '5',
      title: 'Charity Cup',
      date: DateTime(_now.year, _now.month, _now.day + 4, 16, 45),
      location: 'Rotterdam',
      minPlayers: 8,
      capacity: 14,
      isPrivate: true,
      attendees: ['Luis', 'Tim', 'Hana'],
      waitlist: [],
      duration: const Duration(minutes: 105),
    ),
    Match(
      id: '6',
      title: 'Neighborhood League',
      date: DateTime(_now.year, _now.month, _now.day + 5, 12, 0),
      location: 'Utrecht',
      minPlayers: 8,
      capacity: 13,
      isPrivate: false,
      attendees: ['Ariel'],
      waitlist: [],
      duration: const Duration(minutes: 75),
    ),
  ];

  @override
  State<UpcomingMatchesScreen> createState() => _UpcomingMatchesScreenState();
}

class _UpcomingMatchesScreenState extends State<UpcomingMatchesScreen> {
  void _toggleParticipation(Match match) {
    setState(() {
      final name = widget.user.name;
      if (match.attendees.contains(name)) {
        match.attendees.remove(name);
      } else if (match.waitlist.contains(name)) {
        match.waitlist.remove(name);
      } else {
        if (match.isPrivate) {
          match.waitlist.add(name);
        } else if (match.attendees.length < match.capacity) {
          match.attendees.add(name);
        }
      }
    });
  }

  void _showCreateMatchDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();
    final minController = TextEditingController();
    final maxController = TextEditingController();
    String? selectedLocation;
    bool isPrivate = false;
    final cities = ['Alkmaar', 'Heiloo', 'Castricum', 'Amsterdam', 'Rotterdam', 'Utrecht'];

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
                    decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  ),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(labelText: 'Start Time (HH:MM)'),
                  ),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    items: cities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setStateDialog(() {
                        selectedLocation = val;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  TextField(
                    controller: minController,
                    decoration: const InputDecoration(labelText: 'Min Players'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: maxController,
                    decoration: const InputDecoration(labelText: 'Max Players (10-16)'),
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
                  final durationMinutes =
                      int.tryParse(durationController.text) ?? 0;
                  final dateStr = dateController.text;
                  final timeStr = timeController.text;
                  final date =
                      DateTime.tryParse('$dateStr $timeStr') ?? DateTime.now();
                  if (date.minute % 15 != 0) {
                    return;
                  }
                  final match = Match(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    date: date,
                    location: selectedLocation ?? cities.first,
                    minPlayers: minPlayers,
                    capacity: maxPlayers,
                    isPrivate: isPrivate,
                    attendees: [],
                    waitlist: [],
                    duration: Duration(minutes: durationMinutes),
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
                final date = match.date.toLocal();
                final dateStr =
                    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
                    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                final isPlayer = match.attendees.contains(widget.user.name);
                final isWaitlisted = match.waitlist.contains(widget.user.name);
                String buttonText;
                Color buttonColor = const Color(0xFF87CEFA);
                if (isPlayer) {
                  buttonText = 'Withdraw';
                  buttonColor = Colors.red;
                } else if (isWaitlisted) {
                  buttonText = 'Leave Waitlist';
                  buttonColor = Colors.orange;
                } else {
                  buttonText = match.isPrivate ? 'Join Waitlist' : 'Join';
                }
                return Card(
                  color: const Color(0xFFE1F5FE),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      match.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$dateStr @ ${match.location}'),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                  text:
                                      'Players: ${match.attendees.length}/${match.capacity} | '),
                              TextSpan(
                                text: match.isPrivate ? 'Private' : 'Public',
                                style: TextStyle(
                                    color: match.isPrivate
                                        ? Colors.red
                                        : Colors.green),
                              ),
                              TextSpan(
                                  text:
                                      ' | Duration: ${match.duration.inMinutes}m'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _toggleParticipation(match),
                      child: Text(buttonText),
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

