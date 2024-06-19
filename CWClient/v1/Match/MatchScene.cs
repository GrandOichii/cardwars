using Godot;
using System;

namespace CWClient.v1;

public partial class MatchScene : Control
{
	#region Nodes

	public PlayerScene Player1Node { get; set; }
	public PlayerScene Player2Node { get; set; }

	#endregion

	public override void _Ready()
	{
		#region Node fetching

		Player1Node = GetNode<PlayerScene>("%Player1");
		Player2Node = GetNode<PlayerScene>("%Player2");

		#endregion

		Player1Node.PlayerIdx = 0;
		Player2Node.PlayerIdx = 1;
	}

	public void Load(GameMatch match) {
		Player1Node.Load(match);
		Player2Node.Load(match);
	}
}
