extends CardBehavior
class_name HandCardBehavior

@export_group('Colors')
@export var DefaultColor: Color
@export var PlayableColor: Color
@export var HoverColor: Color

var _bg_color: Color = DefaultColor
var _last: Variant

func load_snapshot(card: Variant):
	_last = card

func can_play() -> bool:
	return Controller.can_play(_last)
	
func mouse_enter():
	if not can_play():
		return
	set_bg_color(HoverColor)
	
func mouse_leave():
	set_bg_color(_bg_color)
	
func click():
	if not can_play():
		return
	Controller.play(_last)

func OnUpdate(update: Variant):
	super.OnUpdate(update)
	_bg_color = DefaultColor
	if can_play():
		_bg_color = PlayableColor
	set_bg_color(_bg_color)
