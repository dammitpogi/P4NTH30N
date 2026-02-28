// Drop and recreate N3XT view to expose embedded game data from QU3UE
db = db.getSiblingDB("P4NTHE0N");
db.runCommand({ drop: "N3XT" });
db.createView("N3XT", "QU3UE", [
  { $match: { Unlocked: true } },
  { $sort: { Updated: 1 } },
  { $limit: 1 },
  { $project: { game: 1, _id: 0 } }
]);
