using System.Collections.Generic;
using MongoDB.Bson;
using P4NTHE0N.C0MMON;

namespace P4NTHE0N.C0MMON.Interfaces;

public interface IStoreErrors
{
	void Insert(ErrorLog error);
	List<ErrorLog> GetAll();
	List<ErrorLog> GetBySource(string source);
	List<ErrorLog> GetUnresolved();
	void MarkResolved(ObjectId id);
}
