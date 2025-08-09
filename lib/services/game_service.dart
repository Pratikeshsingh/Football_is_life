import 'package:supabase_flutter/supabase_flutter.dart';

/// Service layer for interacting with game-related tables in Supabase.
class GameService {
  GameService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Fetch upcoming games ordered by start time.
  Future<List<Map<String, dynamic>>> fetchUpcomingGames() async {
    final response = await _client
        .from('games')
        .select('id,title,start_time,location,cap,min,state,organizer_id')
        .gte('start_time', DateTime.now().toUtc().toIso8601String())
        .order('start_time');

    return List<Map<String, dynamic>>.from(response);
  }

  /// Retrieve organizer contact information for a specific game.
  Future<Map<String, dynamic>?> fetchOrganizerContact(String gameId) async {
    final response = await _client
        .from('organizer_contacts')
        .select('display_name, organizer_phone')
        .eq('game_id', gameId)
        .maybeSingle();
    return response;
  }

  /// As an organizer, load attendee phone numbers for a game.
  Future<List<Map<String, dynamic>>> fetchAttendeeProfiles(String gameId) async {
    final attendeeIds = await _client
        .from('rsvps')
        .select('user_id')
        .eq('game_id', gameId) as List;

    final ids = attendeeIds.map((e) => e['user_id'] as String).toList();
    if (ids.isEmpty) {
      return [];
    }

    final profiles = await _client
        .from('profiles')
        .select('id, display_name, phone')
        .in_('id', ids) as List<dynamic>;

    return List<Map<String, dynamic>>.from(profiles);
  }
}
