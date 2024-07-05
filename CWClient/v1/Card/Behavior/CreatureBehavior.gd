extends InPlayCardBehavior
class_name CreatureBehavior

@export_group('Colors')
@export var CanAttackColor: Color
@export var AttackHoverColor: Color

var player_idx: int
var lane_idx: int

func can_attack() -> bool:
	if Controller == null:
		return false
	return Controller.can_attack(player_idx, lane_idx)

func can_pick() -> bool:
	if Controller == null:
		return false
	if _last == null:
		return false
	return Controller.can_pick_creature(_last)
	
func determine_bg_color():
	super.determine_bg_color()
	
	if can_attack():
		_bg_color = CanAttackColor
		return
	if can_pick():
		_bg_color = PickColor
		return

func mouse_enter():
	super.mouse_enter()
	if can_attack():
		set_bg_color(AttackHoverColor)
		return
	if can_pick():
		set_bg_color(PickHoverColor)
		return
	
func click():
	super.click()
	
	if can_attack():
		Controller.attack(lane_idx)
		return
	if can_pick():
		Controller.pick_creature(_last)
		return
