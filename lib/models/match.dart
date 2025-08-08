class Match {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final int minPlayers;
  final int capacity;
  final bool isPrivate;
  final List<String> attendees;

  Match({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.minPlayers,
    required this.capacity,
    required this.isPrivate,
    required this.attendees,
  });

  bool get isUpcoming => date.isAfter(DateTime.now());
}
