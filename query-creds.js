// Query MongoDB for FireKirin credentials with balance > 0
db = db.getSiblingDB('P4NTH30N');
const creds = db.CRED3N7IAL.find({
  Game: 'FireKirin',
  Enabled: true,
  Locked: false,
  Balance: { $gt: 0 }
}).sort({ Balance: -1 }).limit(5).toArray();

print(JSON.stringify(creds, null, 2));
