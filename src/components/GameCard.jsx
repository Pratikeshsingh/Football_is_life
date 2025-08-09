export default function GameCard({ game }) {
  const isPublic = game.isPublic !== false;
  return (
    <div className="border rounded p-4 bg-white">
      <h3 className="font-semibold">{game.title}</h3>
      <p>{new Date(game.startTime).toLocaleString()}</p>
      <p>{(game.going ? game.going.length : 0)}/{game.cap}</p>
      <p className="mt-2 text-sm text-gray-600">{isPublic ? 'Public' : 'Private'}</p>
    </div>
  );
}
