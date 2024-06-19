using System.IO;

namespace CWClient.v1;

public partial class TestMatch : Control
{
	#region Nodes

	public MatchScene MatchNode { get; set; }

	#endregion

	public override void _Ready()
	{
		#region Node fetching

		MatchNode = GetNode<MatchScene>("%Match");

		#endregion

		_ = Test();
	}

	public async Task Test() {
		var view = new SceneMatchView(MatchNode);
		var match = await CreateMatch(view);
		GD.Print("START");
		_ = match.Run();
	}

	public static async Task<GameMatch> CreateMatch(SceneMatchView view) {
		var seed = 0;
		var config = new MatchConfig() {
			FreeDraw = 1,
			StartingLifeTotal = 25,
			ActionPointsPerTurn = 10,
			LaneCount = 4,
			StrictMode = false,
			CardDrawCost = 1,
			StartHandSize = 5,
			CheckLandscapesForPlayingCards = false,
			CanFloopOnFirstTurn = true,
			CanAttackOnFirstTurn = true,
			MaxBuildingsPerLane = 1,
		};

		var cm = new FileCardMaster();
		cm.Load("../CWCore/cards");
		cm.Load("../CWCore/dev-cards");

		var deckText = File.ReadAllText("test-decks/all.json");
		var deck1 = JsonSerializer.Deserialize<DeckTemplate>(deckText)
			?? throw new Exception("failed to read deck file")
		;
		var deck2 = deck1;
		GD.Print("start adding players");

		var controller1 = new TestPlayerController(
			new RandomPlayerController(seed),
			1000
		);
		var controller2 = controller1;

		var match = new GameMatch(config, seed, cm, File.ReadAllText("../CWCore/core.lua"))
		{
			View = view,
		};

		await match.AddPlayer("player1", deck1, controller1);
		await match.AddPlayer("player2", deck2, controller2);

		return match;
	}
}
