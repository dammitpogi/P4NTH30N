using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON;

[BsonIgnoreExtraElements]
public class GameSettings(string game) {
	public string Game { get; set; } = game;
	public string Preferred { get; set; } = "FortunePiggy";

	public bool SpinGrand { get; set; } = true;
	public bool SpinMajor { get; set; } = true;
	public bool SpinMinor { get; set; } = true;
	public bool SpinMini { get; set; } = true;

	public bool Hidden { get; set; } = false;

	public Gold777_Settings Gold777 { get; set; } = new();
	public FortunePiggy_Settings FortunePiggy { get; set; } = new();
	public Quintuple5X_Settings Quintuple5X { get; set; } = new();
}

public class Gold777_Settings {
	public int Page { get; set; } = 1;
	public int Button_X { get; set; } = 0;
	public int Button_Y { get; set; } = 0;
	public bool ButtonVerified { get; set; } = false;
}

public class FortunePiggy_Settings {
	public int Page { get; set; } = 1;
	public int Button_X { get; set; } = 0;
	public int Button_Y { get; set; } = 0;
	public bool ButtonVerified { get; set; } = false;
}

public class Quintuple5X_Settings {
	public int Page { get; set; } = 1;
	public int Button_X { get; set; } = 0;
	public int Button_Y { get; set; } = 0;
	public bool ButtonVerified { get; set; } = false;
}
