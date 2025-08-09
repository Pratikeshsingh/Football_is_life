import 'package:flutter_test/flutter_test.dart';
import 'package:football_is_life/models/match.dart';
import 'package:football_is_life/screens/upcoming_matches_screen.dart';

void main() {
  test('creating a match appends to list', () {
    final original = UpcomingMatchesScreen.matches.length;
    UpcomingMatchesScreen.matches.add(
      Match(
        id: 'test',
        title: 'New Match',
        date: DateTime.now().add(const Duration(days: 1)),
        location: 'Test',
        venue: 'Test Field',
        minPlayers: 8,
        capacity: 10,
        isPrivate: false,
        attendees: [],
        waitlist: [],
        duration: const Duration(minutes: 60),
      ),
    );
    expect(UpcomingMatchesScreen.matches.length, original + 1);
    UpcomingMatchesScreen.matches.removeWhere((m) => m.id == 'test');
  });
}
