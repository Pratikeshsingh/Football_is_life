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
      venue: 'Alkmaar Community Ground',
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
      venue: 'Heiloo Stadium',
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
      venue: 'Castricum Arena',
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
      venue: 'Amsterdam Central Park Field',
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
      venue: 'Rotterdam Charity Field',
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
      venue: 'Utrecht Neighborhood Pitch',
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

class _UpcomingMatchesScreenState extends State<UpcomingMatchesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabController;
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
  void initState() {
    super.initState();
    _fabController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

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
    final venueController = TextEditingController();
    String? selectedLocation;
    bool isPrivate = false;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    bool repeatWeekly = false;
    final cities = ['Alkmaar', 'Heiloo', 'Castricum', 'Amsterdam', 'Rotterdam', 'Utrecht'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Create New Match'),
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
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Date'),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        dateController.text =
                            picked.toLocal().toString().split(' ')[0];
                      }
                    },
                  ),
                  TextField(
                    controller: timeController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Start Time'),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        selectedTime = picked;
                        timeController.text = picked.format(context);
                      }
                    },
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
                    controller: venueController,
                    decoration: const InputDecoration(labelText: 'Location Details'),
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
                  CheckboxListTile(
                    title: const Text('Repeat Weekly'),
                    value: repeatWeekly,
                    onChanged: (val) {
                      setStateDialog(() {
                        repeatWeekly = val ?? false;
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
                  if (selectedDate == null || selectedTime == null) {
                    return;
                  }
                  final date = DateTime(selectedDate!.year, selectedDate!.month,
                      selectedDate!.day, selectedTime!.hour, selectedTime!.minute);
                  if (date.minute % 15 != 0) {
                    return;
                  }
                  setState(() {
                    final baseId = DateTime.now().millisecondsSinceEpoch;
                    final match = Match(
                      id: baseId.toString(),
                      title: titleController.text,
                      date: date,
                      location: selectedLocation ?? cities.first,
                      venue: venueController.text,
                      minPlayers: minPlayers,
                      capacity: maxPlayers,
                      isPrivate: isPrivate,
                      attendees: [],
                      waitlist: [],
                      duration: Duration(minutes: durationMinutes),
                    );
                    UpcomingMatchesScreen.matches.add(match);
                    if (repeatWeekly) {
                      for (int i = 1; i <= 3; i++) {
                        UpcomingMatchesScreen.matches.add(
                          Match(
                            id: '${baseId}_$i',
                            title: titleController.text,
                            date: date.add(Duration(days: 7 * i)),
                            location: selectedLocation ?? cities.first,
                            venue: venueController.text,
                            minPlayers: minPlayers,
                            capacity: maxPlayers,
                            isPrivate: isPrivate,
                            attendees: [],
                            waitlist: [],
                            duration: Duration(minutes: durationMinutes),
                          ),
                        );
                      }
                    }
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
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final myMatches = upcoming
        .where((m) => m.attendees.contains(widget.user.name) || m.waitlist.contains(widget.user.name))
        .toList();
    final otherMatches = upcoming.where((m) => !myMatches.contains(m)).toList();

    final now = DateTime.now();
    final weekEnd = now.add(const Duration(days: 7));
    final monthEnd = DateTime(now.year, now.month + 1, 1);

    final thisWeek = otherMatches.where((m) => m.date.isBefore(weekEnd)).toList();
    final thisMonth = otherMatches
        .where((m) => m.date.isBefore(monthEnd) && m.date.isAfter(weekEnd))
        .toList();
    final later = otherMatches.where((m) => m.date.isAfter(monthEnd)).toList();

    myMatches.sort((a, b) => a.date.compareTo(b.date));
    thisWeek.sort((a, b) => a.date.compareTo(b.date));
    thisMonth.sort((a, b) => a.date.compareTo(b.date));
    later.sort((a, b) => a.date.compareTo(b.date));

    int animationIndex = 0;
    List<Widget> buildSection(String title, List<Match> matches) {
      if (matches.isEmpty) return [];
      final widgets = <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ];
      for (final m in matches) {
        widgets.add(_buildMatchCard(m, animationIndex++));
      }
      return widgets;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEFA),
        title: const Text('Upcoming Matches'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a?auto=format&fit=crop&w=800&q=80'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${widget.user.name}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Joined on: ${widget.user.joinDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ...buildSection('Your Games', myMatches),
            ...buildSection('This Week', thisWeek),
            ...buildSection('This Month', thisMonth),
            ...buildSection('Later', later),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.1).animate(
          CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
        ),
        child: FloatingActionButton.extended(
          onPressed: _showCreateMatchDialog,
          backgroundColor: const Color(0xFF87CEFA),
          foregroundColor: Colors.white,
          label: const Text('Create New'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMatchCard(Match match, int index) {
    final date = match.date.toLocal();
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    final dayName = _weekdays[date.weekday - 1];
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + index * 100),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: child,
        ),
      ),
      child: Card(
        color: const Color(0xFFE1F5FE),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.sports_soccer),
          title: Text(
            match.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$dayName $dateStr @ ${match.location}'),
              const SizedBox(height: 4),
              if (!match.isPrivate) ...[
                Text('Players: ${match.attendees.length}/${match.capacity}'),
                Text('Duration: ${match.duration.inMinutes}m'),
                Chip(
                  label: const Text('Public'),
                  backgroundColor: Colors.green.shade100,
                  visualDensity: VisualDensity.compact,
                ),
              ] else
                Chip(
                  label: const Text('Private'),
                  backgroundColor: Colors.red.shade100,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              key: ValueKey(buttonText),
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
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MatchDetailScreen(
                    match: match, allMatches: UpcomingMatchesScreen.matches),
              ),
            );
          },
        ),
      ),
    );
  }

}

