extends Control
class_name HandCardScene

@export_group('Border Color')
#TODO add better colors

@onready var Card = %Card

var _bg_color: Color

func set_controller(controller: ControllerScene):
	Card.Behavior.set_controller(controller)

func load_snapshot(card: Variant):
	Card.load_snapshot(card)
	Card.Behavior.load_snapshot(card)

# signal connections

func OnMouseEntered():
	Card.Behavior.mouse_enter()

func OnMouseExited():
	Card.Behavior.mouse_leave()

func OnGuiInput(e: InputEvent):
	if e.is_action_pressed('interact'):
		Card.Behavior.click()
