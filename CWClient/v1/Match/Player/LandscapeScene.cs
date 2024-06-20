using System;
using System.Linq;
using CWCore.Match.Players;
using CWCore.Match.States;

namespace CWClient.v1;

public partial class LandscapeScene : Control, ILandscapeScene
{
	#region Signals
	
	[Signal]
	public delegate void CardHoverEventHandler(string cardName);
	
	#endregion
	
	#region Nodes

	public Container OrderContainer { get; private set; }

	public TextureRect BuildingImageNode { get; private set; }
	public TextureRect CreatureImageNode { get; private set; }

	public HttpRequest BuildingImageRequestNode { get; private set; }
	public HttpRequest CreatureImageRequestNode { get; private set; }

	#endregion

	public int PlayerIdx { get; private set; }
	public int LaneIdx { get; private set; }

	private LandscapeState _landscape;

	public override void _Ready()
	{
		#region Node fetching

		OrderContainer = GetNode<Container>("%OrderContainer");
		
		BuildingImageNode = GetNode<TextureRect>("%BuildingImage");
		CreatureImageNode = GetNode<TextureRect>("%CreatureImage");

		BuildingImageRequestNode = GetNode<HttpRequest>("%BuildingImageRequest");
		CreatureImageRequestNode = GetNode<HttpRequest>("%CreatureImageRequest");

		#endregion
	}

	// TODO repeated code
	public static string CardNameToUrl(string cardName) => $"http://localhost:1323/{Uri.EscapeDataString(cardName)}";

	public void FlipOrdering() {
		var count = OrderContainer.GetChildCount();
		for (int i = 0; i < count; i++)
			OrderContainer.MoveChild(OrderContainer.GetChild(i), 0);
	}
	
	public void Load(GameMatch match) {
		var player = match.GetPlayerState(PlayerIdx);
		_landscape = player.Landscapes[LaneIdx];

		// building
		if (_landscape.Buildings.Count == 0) {
			BuildingImageNode.Texture = null;
		} else {
			var url = CardNameToUrl(_landscape.Buildings.First().Original.Card.Template.Name);
			BuildingImageRequestNode.CancelRequest();
			BuildingImageRequestNode.Request(url);
		}

		// creature
		if (_landscape.Creature is null) {
			CreatureImageNode.Texture = null;
		} else {
			var url = CardNameToUrl(_landscape.Creature.Original.Card.Template.Name);
			CreatureImageRequestNode.CancelRequest();
			CreatureImageRequestNode.Request(url);
		}
	}

	public void SetPlayerIdx(int idx)
	{
		PlayerIdx = idx;
	}

	public void SetLaneIdx(int idx)
	{
		LaneIdx = idx;
	}

	public void ConnectCardHover(Action<string> a)
	{
		CardHover += a.Invoke;
	}


	#region Signal connections

	private void OnBuildingImageRequestRequestCompleted(long result, long response_code, string[] headers, byte[] body)
	{
		if (result != (long)HttpRequest.Result.Success) {
			// TODO
			GD.Print("Failed to top card of discard");
			return;
		}
		var image = new Image();
		image.LoadJpgFromBuffer(body);
		var texture = ImageTexture.CreateFromImage(image);

		// TODO cache texture
		BuildingImageNode.Texture = texture;
	}

	private void OnCreatureImageRequestRequestCompleted(long result, long response_code, string[] headers, byte[] body)
	{
		if (result != (long)HttpRequest.Result.Success) {
			// TODO
			GD.Print("Failed to top card of discard");
			return;
		}
		var image = new Image();
		image.LoadJpgFromBuffer(body);
		var texture = ImageTexture.CreateFromImage(image);

		// TODO cache texture
		CreatureImageNode.Texture = texture;
	}

	private void OnCreatureImageMouseEntered()
	{
		if (_landscape.Creature is null) return;

		GD.Print(_landscape.Creature);
		EmitSignal(SignalName.CardHover, _landscape.Creature.Original.Card.Template.Name);
	}

	private void OnBuildingImageMouseEntered()
	{
		if (_landscape.Buildings.Count == 0) return;

		EmitSignal(SignalName.CardHover, _landscape.Buildings.First().Original.Card.Template.Name);
	}

	#endregion
}



