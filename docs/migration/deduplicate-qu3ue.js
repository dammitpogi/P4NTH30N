// Deduplicate QU3UE entries by House/Name, keeping the earliest Updated entry
db = db.getSiblingDB("P4NTHE0N");
db.QU3UE.aggregate([
  { $sort: { House: 1, Name: 1, Updated: 1 } },
  { $group: {
      _id: { House: "$House", Name: "$Name" },
      firstId: { $first: "$_id" }
    }
  }
]).forEach(group => {
  db.QU3UE.deleteMany({
    House: group._id.House,
    Name: group._id.Name,
    _id: { $ne: group.firstId }
  });
});
