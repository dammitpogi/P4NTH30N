db = db.getSiblingDB("P4NTHE0N");
// Build a map of G4ME by key House|Name
const g4mes = db.G4ME.find({}).toArray();
const g4meMap = {};
for (const g of g4mes) {
  const key = (g.House || "") + "||" + (g.Name || "");
  const { _id, ...rest } = g;
  g4meMap[key] = rest;
}

const queueCursor = db.QU3UE.find({});
while (queueCursor.hasNext()) {
  const q = queueCursor.next();
  const key = (q.House || (q.game && q.game.House) || "") + "||" + (q.Name || (q.game && q.game.Name) || "");
  const gData = g4meMap[key];
  if (gData) {
    const embedded = Object.assign({}, gData);
    db.QU3UE.updateOne({ _id: q._id }, { $set: { game: embedded } });
  } else {
    // No match found; skip
  }
}

// After embedding, drop the G4ME collection if it exists
if (db.G4ME && db.G4ME.countDocuments) {
  try {
    if (db.G4ME.countDocuments() > 0) {
      db.G4ME.drop();
    }
  } catch (e) {
    // If collection doesn't exist or other drop error, log and continue
    print("Warning: could not drop G4ME -", e.message);
  }
}
