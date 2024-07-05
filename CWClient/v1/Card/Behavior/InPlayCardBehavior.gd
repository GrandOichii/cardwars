extends CardBehavior
class_name InPlayCardBehavior

@export_group('Colors')
@export var DefaultColor: Color

var _bg_color = DefaultColor

func mouse_leave():
	set_bg_color(_bg_color)

func determine_bg_color():
	_bg_color = DefaultColor

func OnUpdate(update: Variant):
	super.OnUpdate(update)
	_bg_color = DefaultColor
	determine_bg_color()
	set_bg_color(_bg_color)
