// React single-file app: shows "my games" and lets you open a game to see signed-up players (no login, no backend)
// - Tailwind classes for styling (no imports needed in this canvas)
// - Includes tiny in-file tests via console.assert at the bottom

import { useState, useMemo } from "react";

export default function App() {
  // Pretend this is the current user. In a real app you'd get this from auth.
  const currentUserId = "user-1";

  // Directory of users so we can show names instead of raw IDs
  const users = [
    { id: "user-1", name: "Asha" },
    { id: "user-2", name: "Ben" },
    { id: "user-3", name: "Carlos" },
    { id: "user-4", name: "Diya" },
    { id: "user-5", name: "Eve" },
  ];

  // Sample games (replace with API later). ISO strings to avoid timezone weirdness.
  const games = [
    {
      id: "g1",
      title: "Monday Night Football",
      dateISO: "2025-08-11T19:00:00+02:00",
      location: "Small Pitch",
      capacity: 14,
      attendees: ["user-1", "user-2", "user-3"],
    },
    {
      id: "g2",
      title: "Thursday Pickup",
      dateISO: "2025-08-14T19:00:00+02:00",
      location: "Cage Court",
      capacity: 10,
      attendees: ["user-3"],
    },
    {
      id: "g3",
      title: "Weekend Kickabout",
      dateISO: "2025-08-17T10:00:00+02:00",
      location: "City Park",
      capacity: 16,
      attendees: ["user-1"],
    },
  ];

  const myGames = useMemo(() => getUserGames(games, currentUserId), [games, currentUserId]);
  const [selectedGameId, setSelectedGameId] = useState(null);
  const selectedGame = useMemo(() => myGames.find((g) => g.id === selectedGameId) || null, [myGames, selectedGameId]);
  const selectedAttendees = useMemo(() => (selectedGame ? getProfilesByIds(users, selectedGame.attendees) : []), [users, selectedGame]);

  return (
    <div className="min-h-screen bg-gray-50 text-gray-900">
      <header className="sticky top-0 bg-white border-b px-4 py-3">
        <h1 className="text-xl font-semibold">My Upcoming Games</h1>
        <p className="text-sm text-gray-500">Showing games you are attending as {currentUserId}</p>
      </header>

      <main className="max-w-2xl mx-auto p-4 space-y-3">
        {myGames.length === 0 ? (
          <EmptyState />
        ) : (
          myGames.map((g) => (
            <button
              key={g.id}
              className="w-full text-left"
              onClick={() => setSelectedGameId(g.id)}
              aria-label={`Open ${g.title}`}
            >
              <GameCard game={g} />
            </button>
          ))
        )}
      </main>

      {/* Simple bottom sheet for game details */}
      {selectedGame && (
        <div className="fixed inset-0 z-50">
          {/* backdrop */}
          <div
            className="absolute inset-0 bg-black/40"
            onClick={() => setSelectedGameId(null)}
            aria-hidden
          />
          {/* sheet */}
          <section className="absolute inset-x-0 bottom-0 bg-white rounded-t-2xl shadow-2xl p-4 border-t max-h-[70vh] overflow-y-auto">
            <div className="flex items-start justify-between gap-4">
              <div>
                <h2 className="text-lg font-semibold">{selectedGame.title}</h2>
                <p className="text-sm text-gray-600">{formatDateTime(selectedGame.dateISO)}</p>
                <p className="text-sm text-gray-600">{selectedGame.location}</p>
              </div>
              <div className="text-right">
                <div className="text-sm">Players</div>
                <div className="text-xl font-semibold">{selectedGame.attendees.length}/{selectedGame.capacity}</div>
              </div>
            </div>

            <div className="mt-4">
              <h3 className="text-sm font-medium text-gray-700 mb-2">Signed-up players</h3>
              <ul className="divide-y">
                {selectedAttendees.length === 0 ? (
                  <li className="py-3 text-gray-500">No attendees yet</li>
                ) : (
                  selectedAttendees.map((p) => (
                    <li key={p.id} className="py-2 flex items-center gap-3">
                      <div className="h-9 w-9 rounded-full bg-gray-100 grid place-items-center">{initials(p.name)}</div>
                      <div className="flex-1">
                        <div className="font-medium">{p.name}</div>
                        <div className="text-xs text-gray-500">{p.id}</div>
                      </div>
                      {p.id === currentUserId && <span className="text-xs px-2 py-1 rounded bg-green-100 text-green-800">You</span>}
                    </li>
                  ))
                )}
              </ul>
            </div>

            <div className="mt-4 flex justify-end">
              <button
                onClick={() => setSelectedGameId(null)}
                className="px-4 py-2 rounded-xl bg-gray-900 text-white hover:bg-black"
              >
                Close
              </button>
            </div>
          </section>
        </div>
      )}
    </div>
  );
}

function GameCard({ game }) {
  return (
    <article className="bg-white rounded-2xl shadow p-4 border">
      <div className="flex items-start justify-between gap-4">
        <div>
          <h2 className="text-lg font-medium">{game.title}</h2>
          <p className="text-sm text-gray-600">{formatDateTime(game.dateISO)}</p>
          <p className="text-sm text-gray-600">{game.location}</p>
        </div>
        <div className="text-right">
          <div className="text-sm">Players</div>
          <div className="text-xl font-semibold">{game.attendees.length}/{game.capacity}</div>
        </div>
      </div>
      <p className="mt-3 text-xs text-gray-500">Tap to view attendees</p>
    </article>
  );
}

function EmptyState() {
  return (
    <div className="text-center py-16">
      <div className="text-5xl mb-2">⚽️</div>
      <p className="text-gray-700 font-medium">No upcoming games</p>
      <p className="text-gray-500 text-sm">You aren't on the attendee list for any future games.</p>
    </div>
  );
}

// --- Logic helpers ---
function getUserGames(games, userId) {
  return (games || [])
    .filter((g) => Array.isArray(g.attendees) && g.attendees.includes(userId))
    .filter((g) => isFuture(g.dateISO))
    .sort((a, b) => new Date(a.dateISO) - new Date(b.dateISO));
}

function getProfilesByIds(allUsers, ids) {
  const index = new Map((allUsers || []).map((u) => [u.id, u]));
  return (ids || []).map((id) => index.get(id)).filter(Boolean);
}

function initials(name) {
  if (!name) return "?";
  const parts = String(name).trim().split(/\s+/);
  if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
  return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}

function isFuture(iso) {
  const d = new Date(iso);
  return d.getTime() > Date.now();
}

function formatDateTime(iso) {
  const d = new Date(iso);
  // Show local time (Europe/Amsterdam on your device)
  try {
    return d.toLocaleString(undefined, {
      weekday: "short",
      year: "numeric",
      month: "short",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    });
  } catch {
    return d.toString();
  }
}

// --- Tiny tests (console) ---
(function runTests() {
  const uid = "me";
  const sample = [
    { id: "a", dateISO: futureMinutes(30), attendees: [uid], capacity: 10, title: "A", location: "X" },
    { id: "b", dateISO: futureMinutes(10), attendees: [uid], capacity: 10, title: "B", location: "Y" },
    { id: "c", dateISO: pastMinutes(5), attendees: [uid], capacity: 10, title: "C", location: "Z" }, // past: should be filtered out
    { id: "d", dateISO: futureMinutes(5), attendees: ["other"], capacity: 10, title: "D", location: "Z" }, // not mine
  ];

  const res = getUserGames(sample, uid);
  console.assert(res.length === 2, `Expected 2 of my upcoming games, got ${res.length}`);
  console.assert(res[0].id === "b" && res[1].id === "a", "Games should be sorted soonest-first");

  const none = getUserGames([], uid);
  console.assert(Array.isArray(none) && none.length === 0, "Empty input should return empty output");

  // New tests for getProfilesByIds
  const people = [
    { id: "u1", name: "Ada Lovelace" },
    { id: "u2", name: "Grace Hopper" },
    { id: "u3", name: "Alan Turing" },
  ];
  const ordered = getProfilesByIds(people, ["u3", "u1"]);
  console.assert(ordered.length === 2, "Expected to resolve 2 profiles");
  console.assert(ordered[0].id === "u3" && ordered[1].id === "u1", "Profiles should preserve input order");
  const filtered = getProfilesByIds(people, ["uX", "u2"]).map((p) => p.id).join(",");
  console.assert(filtered === "u2", "Unknown IDs should be skipped");

  console.log("✅ All in-file tests passed");
})();

function futureMinutes(m) {
  return new Date(Date.now() + m * 60 * 1000).toISOString();
}
function pastMinutes(m) {
  return new Date(Date.now() - m * 60 * 1000).toISOString();
}
