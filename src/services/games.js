import { collection, doc, addDoc, updateDoc, arrayUnion, arrayRemove, onSnapshot, query, orderBy } from 'firebase/firestore';
import { db } from '../firebase';

export function subscribeUpcomingGames(cb) {
  const q = query(collection(db, 'games'), orderBy('startTime'));
  return onSnapshot(q, snap => {
    cb(snap.docs.map(d => ({ id: d.id, ...d.data() })));
  });
}

export async function createGame(data) {
  const ref = collection(db, 'games');
  await addDoc(ref, data);
}

export async function rsvpGame(id, uid) {
  const ref = doc(db, 'games', id);
  await updateDoc(ref, { going: arrayUnion(uid) });
}

export async function leaveGame(id, uid) {
  const ref = doc(db, 'games', id);
  await updateDoc(ref, { going: arrayRemove(uid) });
}
