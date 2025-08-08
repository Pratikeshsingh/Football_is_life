class Match {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final int capacity;
  final List<String> attendees;

  Match({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.capacity,
    required this.attendees,
  });

  bool get isUpcoming => date.isAfter(DateTime.now());
}
