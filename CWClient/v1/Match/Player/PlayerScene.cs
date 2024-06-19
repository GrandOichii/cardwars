using Godot;
using System;

public partial class PlayerScene : Control
{
	#region Nodes
	
	public Label LifeLabel { get; private set; }
	
	#endregion
	
	public override void _Ready()
	{
		#region Node fetching
	
		LifeLabel = GetNode<Label>("%LifeLabel");
		
		#endregion
		
		LifeLabel.Text = "Amogus";
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
