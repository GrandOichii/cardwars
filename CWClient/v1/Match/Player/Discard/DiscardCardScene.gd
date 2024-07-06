extends Control
class_name DiscardCardScene

@onready var Card = %Card

func set_controller(controller: ControllerScene):
	Card.Behavior.set_controller(controller)

func load_snapshot(card: Variant):
	Card.load_snapshot(card)
	Card.Behavior.load_snapshot(card)
	
func set_discard_idx(discard_idx: int):
	Card.Behavior.set_discard_idx(discard_idx)
	
func set_player_idx(player_idx: int):
	Card.Behavior.set_player_idx(player_idx)

# signal connections

func OnGuiInput(e):
	if e.is_action_pressed('interact'):
		Card.Behavior.click()

func OnMouseEntered():
	Card.Behavior.mouse_enter()

func OnMouseExited():
	Card.Behavior.mouse_leave()
