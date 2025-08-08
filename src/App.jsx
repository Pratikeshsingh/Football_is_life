import { useEffect, useState } from 'react';
import AuthGate from './components/AuthGate';
import GameCard from './components/GameCard';
import GameDetail from './components/GameDetail';
import { subscribeUpcomingGames } from './services/games';
import { auth } from './firebase';

export default function App() {
  const [games, setGames] = useState([]);
  const [selected, setSelected] = useState(null);

  useEffect(() => {
    const unsub = subscribeUpcomingGames(setGames);
    return unsub;
  }, []);

  const user = auth.currentUser;

  return (
    <AuthGate>
      <div>
        <h1>Football Is Life</h1>
        {selected ? (
          <div>
            <button onClick={() => setSelected(null)}>Back</button>
            <GameDetail game={selected} user={user} />
          </div>
        ) : (
          games.map(g => (
            <div key={g.id} onClick={() => setSelected(g)}>
              <GameCard game={g} />
            </div>
          ))
        )}
      </div>
    </AuthGate>
  );
}
