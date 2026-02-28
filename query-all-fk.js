// Query all FireKirin credentials to see what's available
db = db.getSiblingDB('P4NTHE0N');
const creds = db.CRED3N7IAL.find({
  Game: 'FireKirin'
}).sort({ Balance: -1 }).limit(10).toArray();

print("Total FireKirin credentials:", db.CRED3N7IAL.countDocuments({ Game: 'FireKirin' }));
print("\nTop 10 by balance:");
creds.forEach(c => {
  print(`Username: ${c.Username}, Balance: ${c.Balance}, Enabled: ${c.Enabled}, Locked: ${c.Locked}, Banned: ${c.Banned}`);
});
