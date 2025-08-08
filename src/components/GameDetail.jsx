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
    <div>
      <GameCard game={game} />
      {isGoing ? (
        <button onClick={leave} disabled={saving}>Leave</button>
      ) : (
        <button onClick={join} disabled={saving}>Join</button>
      )}
    </div>
  );
}
