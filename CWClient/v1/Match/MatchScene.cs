using Godot;
using System;

namespace CWClient.v1;

public partial class MatchScene : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	public void Load(GameMatch match) {
		GD.Print("LOAD");
	}
}
