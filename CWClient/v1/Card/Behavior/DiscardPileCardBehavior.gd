extends CardBehavior
class_name DiscardPileCardBehavior

@export_group('Colors')
@export var DefaultColor: Color
@export var PickColor: Color
@export var PickHoverColor: Color

var _bg_color: Color = DefaultColor
var _last: Variant
var _discard_idx: int
var _player_idx: int

func set_discard_idx(discard_idx: int):
	_discard_idx = discard_idx
	
func set_player_idx(player_idx: int):
	_player_idx = player_idx

func load_snapshot(card: Variant):
	_last = card

func can_pick() -> bool:
	return Controller.can_pick_card_in_discard(_player_idx, _discard_idx)
	
func mouse_enter():
	if can_pick():
		set_bg_color(PickHoverColor)
		return
	
func mouse_leave():
	set_bg_color(_bg_color)
	
func click():
	if can_pick():
		Controller.pick_card_in_discard(_player_idx, _discard_idx)

func OnUpdate(update: Variant):
	super.OnUpdate(update)
	_bg_color = DefaultColor
	if can_pick():
		_bg_color = PickColor
	set_bg_color(_bg_color)
