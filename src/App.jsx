import { useEffect, useState } from 'react';
import AuthGate from './components/AuthGate';
import GameCard from './components/GameCard';
import GameDetail from './components/GameDetail';
import { subscribeUpcomingGames } from './services/games';
import { auth } from './firebase';

function HomeTab({ user, games, status, setStatus, onSelect }) {
  const joined = games.filter(g => (g.going || []).includes(user.uid));
  const now = Date.now();
  const upcoming = joined.filter(g => g.startTime > now).slice(0, 3);
  const past = joined.filter(g => g.startTime <= now).slice(-3);
  const lastActive = user?.metadata?.lastSignInTime
    ? new Date(user.metadata.lastSignInTime).toLocaleDateString()
    : 'Unknown';
  return (
    <div>
      <h2>Your Info</h2>
      <p>Phone: {user.phoneNumber}</p>
      <p>Status: {status}</p>
      <p>Last active: {lastActive}</p>
      <label>
        Update status:
        <select value={status} onChange={e => setStatus(e.target.value)}>
          <option value="Available">Available</option>
          <option value="Injured">Injured</option>
          <option value="On Vacation">On Vacation</option>
        </select>
      </label>
      <h3 className="mt-4">Upcoming Games</h3>
      {upcoming.length ? upcoming.map(g => (
        <div key={g.id} onClick={() => onSelect(g)}>
          <GameCard game={g} />
        </div>
      )) : <p>No upcoming games</p>}
      <h3 className="mt-4">Recent Games</h3>
      {past.length ? past.map(g => (
        <div key={g.id} onClick={() => onSelect(g)}>
          <GameCard game={g} />
        </div>
      )) : <p>No past games</p>}
    </div>
  );
}

function GamesTab({ games, onSelect }) {
  return (
    <div>
      {games.map(g => (
        <div key={g.id} onClick={() => onSelect(g)}>
          <GameCard game={g} />
        </div>
      ))}
    </div>
  );
}

function LeaguesTab({ user, games, onSelect }) {
  const joined = games.filter(g => (g.going || []).includes(user.uid));
  if (!joined.length) {
    return <p>No leagues yet. Join a game to get started.</p>;
  }
  return (
    <div>
      {joined.map(g => (
        <div key={g.id} onClick={() => onSelect(g)}>
          <GameCard game={g} />
        </div>
      ))}
    </div>
  );
}

export default function App() {
  const [games, setGames] = useState([]);
  const [selected, setSelected] = useState(null);
  const [tab, setTab] = useState('home');
  const [status, setStatus] = useState(localStorage.getItem('status') || 'Available');

  useEffect(() => {
    const unsub = subscribeUpcomingGames(setGames);
    return unsub;
  }, []);

  useEffect(() => {
    localStorage.setItem('status', status);
  }, [status]);

  const user = auth.currentUser;

  return (
    <AuthGate>
      <div>
        <h1>Football Is Life</h1>
        <nav className="space-x-4 mb-4">
          <button onClick={() => setTab('home')}>Home</button>
          <button onClick={() => setTab('games')}>Games</button>
          <button onClick={() => setTab('leagues')}>Leagues</button>
        </nav>
        {selected ? (
          <div>
            <button onClick={() => setSelected(null)}>Back</button>
            <GameDetail game={selected} user={user} />
          </div>
        ) : (
          <>
            {tab === 'home' && (
              <HomeTab user={user} games={games} status={status} setStatus={setStatus} onSelect={setSelected} />
            )}
            {tab === 'games' && (
              <GamesTab games={games} onSelect={setSelected} />
            )}
            {tab === 'leagues' && (
              <LeaguesTab user={user} games={games} onSelect={setSelected} />
            )}
          </>
        )}
      </div>
    </AuthGate>
  );
}
