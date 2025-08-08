export default function GameCard({ game }) {
  return (
    <div className="border rounded p-4">
      <h3 className="font-semibold">{game.title}</h3>
      <p>{new Date(game.startTime).toLocaleString()}</p>
      <p>{(game.going ? game.going.length : 0)}/{game.cap}</p>
    </div>
  );
}
