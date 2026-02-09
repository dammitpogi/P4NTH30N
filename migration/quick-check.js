db = db.getSiblingDB("P4NTH30N");
const nextGame = db.N3XT.findOne();
print("N3XT.next:", JSON.stringify(nextGame, null, 2));

print("QU3UE sample (first 5):");
db.QU3UE.find({}).limit(5).forEach(doc => printjson(doc));
