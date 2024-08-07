extends Control
class_name HandCardScene

@onready var Card = %Card

func set_controller(controller: ControllerScene):
	Card.Behavior.set_controller(controller)

func load_snapshot(card: Variant):
	Card.load_snapshot(card)
	Card.Behavior.load_snapshot(card)
	
func set_hand_idx(hand_idx: int):
	Card.Behavior.set_hand_idx(hand_idx)

# signal connections

func OnMouseEntered():
	Card.Behavior.mouse_enter()

func OnMouseExited():
	Card.Behavior.mouse_leave()

func OnGuiInput(e: InputEvent):
	if e.is_action_pressed('interact'):
		Card.Behavior.click()
