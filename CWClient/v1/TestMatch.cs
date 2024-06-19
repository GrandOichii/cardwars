using System.IO;
using Microsoft.Extensions.Logging;

namespace CWClient.v1;

class GDLogger : ILogger
{
    public IDisposable BeginScope<TState>(TState state) where TState : notnull => default!;

	// TODO
	public bool IsEnabled(LogLevel logLevel) => true;

	public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
	{
		var log = formatter(state, exception);
		GD.Print(log);
	}
}

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
		_ = RunMatch(match);
	}

	private async Task RunMatch(GameMatch match) {
		try {
			await match.Run();
		} catch (Exception e) {
			GD.Print(e.ToString());
		}
	} 

	private static async Task<GameMatch> CreateMatch(SceneMatchView view) {
		var seed = 0;
		var config = new MatchConfig() {
			FreeDraw = 1,
			StartingLifeTotal = 25,
			ActionPointsPerTurn = 2,
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

		var controller1 = new TestPlayerController(
			new RandomPlayerController(seed),
			100
		);
		var controller2 = controller1;

		var match = new GameMatch(config, seed, cm, File.ReadAllText("../CWCore/core.lua"))
		{
			View = view,
			Logger = new GDLogger()
		};

		await match.AddPlayer("player1", deck1, controller1);
		await match.AddPlayer("player2", deck2, controller2);

		return match;
	}
}
