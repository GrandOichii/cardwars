using CWCore.Match.Players;
using Godot;
using System;
using System.Linq;
using System.Net.Http;

namespace CWClient.v1;

public partial class PlayerScene : Control
{
	#region Packed scenes
	
	[Export]
	public PackedScene LandscapeScenePS { get; set; }
	
	#endregion

	#region Exports

	[Export]
	public bool IsOpponentIntitial { get; set; } = false;

	#endregion

	#region Nodes

	public Container InfoContainerNode { get; private set; }
	public Label NameLabelNode { get; private set; }
	public Container LandscapeContainerNode { get; private set; }
	public Label LifeLabelNode { get; private set; }
	public Label DiscardCountLabelNode { get; private set; }
	public Label DeckCountLabelNode { get; private set; }
	public Label HandSizeLabelNode { get; private set; }
	public TextureRect DiscardImageNode { get; private set; }
	public TextureRect HeroImageNode { get; private set; }

	public HttpRequest TopDiscardCardImageRequestNode { get; private set; }
	public HttpRequest HeroCardImageRequestNode { get; private set; }

	#endregion

	public int PlayerIdx { get; set; } = -1;

	public override void _Ready()
	{
		#region Node fetching

		InfoContainerNode = GetNode<Container>("%InfoContainer");
		NameLabelNode = GetNode<Label>("%NameLabel");
		LandscapeContainerNode = GetNode<Container>("%LandscapeContainer");
		LifeLabelNode = GetNode<Label>("%LifeLabel");
		DiscardCountLabelNode = GetNode<Label>("%DiscardCountLabel");
		DeckCountLabelNode = GetNode<Label>("%DeckCountLabel");
		HandSizeLabelNode = GetNode<Label>("%HandSizeLabel");
		DiscardImageNode = GetNode<TextureRect>("%DiscardImage");
		HeroImageNode = GetNode<TextureRect>("%HeroImage");

		TopDiscardCardImageRequestNode = GetNode<HttpRequest>("%TopDiscardCardImageRequest");
		HeroCardImageRequestNode = GetNode<HttpRequest>("%HeroCardImageRequest");

		#endregion
	}

	public void FlipOrdering() {
		// player info
		var count = InfoContainerNode.GetChildCount();
		for (int i = 0; i < count; i++)
			InfoContainerNode.MoveChild(InfoContainerNode.GetChild(i), 0);

		// landscapes
		foreach (var child in LandscapeContainerNode.GetChildren())
			if (child is LandscapeScene landscape)
				landscape.FlipOrdering();
	}

	public static string CardNameToUrl(string cardName) => $"http://localhost:1323/{Uri.EscapeDataString(cardName)}";

	public void Load(GameMatch match) {
		var player = match.GetPlayerState(PlayerIdx);

		// general info
		NameLabelNode.Text = player.Original.Name;
		LifeLabelNode.Text = player.Original.Life.ToString();
		DeckCountLabelNode.Text = player.Original.Deck.Count.ToString();
		HandSizeLabelNode.Text = player.Original.Hand.Count.ToString();

		// discard
		DiscardCountLabelNode.Text = player.Original.DiscardPile.Count.ToString();
		if (player.DiscardPile.Count == 0) {
			DiscardImageNode.Texture = null;
		} else {
			var url = CardNameToUrl(player.DiscardPile.Last().Original.Template.Name);
			TopDiscardCardImageRequestNode.CancelRequest();
			TopDiscardCardImageRequestNode.Request(url);
		}

		// hero
		if (player.Original.Hero is null) {
			HeroImageNode.Texture = null;
		} else {
			var url = CardNameToUrl(player.Original.Hero.Template.Name);
			HeroCardImageRequestNode.CancelRequest();
			HeroCardImageRequestNode.Request(url);
		}

		// landscape
		foreach (var child in LandscapeContainerNode.GetChildren())
			if (child is LandscapeScene landscape)
				landscape.Load(match);
	}

	public void LoadConfig(MatchConfig config) {
		for (int i = 0; i < config.LaneCount; i++) {
			var child = LandscapeScenePS.Instantiate();
			LandscapeContainerNode.AddChild(child);

			var landscape = child as ILandscapeScene;
			landscape.SetPlayerIdx(PlayerIdx);
			landscape.SetLaneIdx(i);
			landscape.ConnectCardHover(OnLandscapeCardHover);
		}

		if (IsOpponentIntitial)
			FlipOrdering();
	}
	
	#region Signal connections
	
	private void OnTopDiscardCardImageRequestRequestCompleted(long result, long response_code, string[] headers, byte[] body)
	{
		if (result != (long)HttpRequest.Result.Success) {
			// TODO
			GD.Print("Failed to fetch image of top card of discard");
			return;
		}
		var image = new Image();
		image.LoadJpgFromBuffer(body);
		var texture = ImageTexture.CreateFromImage(image);

		// TODO cache texture
		DiscardImageNode.Texture = texture;
	}
	
	private void OnHeroCardImageRequestRequestCompleted(long result, long response_code, string[] headers, byte[] body)
	{
		if (result != (long)HttpRequest.Result.Success) {
			// TODO
			GD.Print("Failed to fetch image of Hero card");
			return;
		}
		var image = new Image();
		image.LoadJpgFromBuffer(body);
		var texture = ImageTexture.CreateFromImage(image);

		// TODO cache texture
		HeroImageNode.Texture = texture;
	}

	private void OnLandscapeCardHover(string name) {
		GD.Print(name);
	}
	
	#endregion
}



