using System;

public partial class LandscapeScene : Control
{
	#region Nodes

	public Container OrderContainer { get; private set; }

	#endregion

	public override void _Ready()
	{
		#region Node fetching

		OrderContainer = GetNode<Container>("%OrderContainer");

		#endregion
	}

	public void FlipOrdering() {
		var count = OrderContainer.GetChildCount();
		for (int i = 0; i < count; i++)
			OrderContainer.MoveChild(OrderContainer.GetChild(i), 0);
	}
}
