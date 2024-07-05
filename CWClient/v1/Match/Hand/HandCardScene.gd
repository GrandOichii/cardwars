extends Control
class_name HandCardScene

@export_group('Border Color')
#TODO add better colors

@export_color_no_alpha var DefaultColor: Color
@export_color_no_alpha var PlayableColor: Color
@export_color_no_alpha var HoverColor: Color

@onready var Card = %Card
@onready var Bg: ColorRect = %Bg

var _bg_color: Color

var Controller: ControllerScene
var _last: Variant

func _ready():
	_bg_color = DefaultColor

func set_controller(controller: ControllerScene):
	Controller = controller
	Controller.Update.connect(OnUpdate)

func load_snapshot(card: Variant):
	_last = card
	Card.load_snapshot(card)

func can_play() -> bool:
	return Controller.can_play(_last)

func set_bg_color(color: Color):
	Bg.color = color

# signal connections

func OnUpdate(update: Variant):
	_bg_color = DefaultColor
	if can_play():
		_bg_color = PlayableColor
	set_bg_color(_bg_color)

func OnMouseEntered():
	if not can_play():
		return
	set_bg_color(HoverColor)

func OnMouseExited():
	set_bg_color(_bg_color)


func OnGuiInput(e: InputEvent):
	if e.is_action_pressed('play_card'):
		if not can_play():
			return
		Controller.send('p ' + _last.ID)
