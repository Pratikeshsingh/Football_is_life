import GameCard from './GameCard';
import { rsvpGame, leaveGame } from '../services/games';
import { useState } from 'react';

export default function GameDetail({ game, user }) {
  const [saving, setSaving] = useState(false);
  const isGoing = (game.going || []).includes(user.uid);

  const join = async () => {
    setSaving(true);
    await rsvpGame(game.id, user.uid);
    setSaving(false);
  };

  const leave = async () => {
    setSaving(true);
    await leaveGame(game.id, user.uid);
    setSaving(false);
  };

  return (
    <div className="bg-white text-black p-4 rounded shadow">
      <GameCard game={game} />
      {isGoing ? (
        <button className="mt-4 px-4 py-2 bg-red-500 text-white rounded" onClick={leave} disabled={saving}>Leave</button>
      ) : (
        <button className="mt-4 px-4 py-2 bg-green-500 text-white rounded" onClick={join} disabled={saving}>Join</button>
      )}
    </div>
  );
}
