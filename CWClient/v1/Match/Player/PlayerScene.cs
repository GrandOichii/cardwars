using CWCore.Match.Players;
using Godot;
using System;
using System.Linq;
using System.Net.Http;

public partial class PlayerScene : Control
{
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

	public HttpRequest TopDiscardCardImageRequestNode { get; private set; }

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

		TopDiscardCardImageRequestNode = GetNode<HttpRequest>("%TopDiscardCardImageRequest");

		#endregion

		if (IsOpponentIntitial)
			FlipOrdering();
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
			TopDiscardCardImageRequestNode.Request(url);
		}
	}
	
	#region Signal connections
	
	private void OnTopDiscardCardImageRequestRequestCompleted(long result, long response_code, string[] headers, byte[] body)
	{
		GD.Print(result);
		GD.Print(response_code);
		if (result != (long)HttpRequest.Result.Success) {
			// TODO
			GD.Print("Failed to top card of discard");
			return;
		}
		// var image = new Image();
		// var err = image.LoadJpgFromBuffer(body);
		// GD.Print(err);
		//var texture = ImageTexture.CreateFromImage(image);

		// TODO cache texture
		//GD.Print(texture);
		// DiscardImageNode.Texture = texture;
	}
	
	#endregion
}

