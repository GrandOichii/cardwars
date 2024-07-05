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
	
func determine_bg_color():
	if can_attack():
		_bg_color = CanAttackColor

func mouse_enter():
	super.mouse_enter()
	if can_attack():
		set_bg_color(AttackHoverColor)
		return
	
func click():
	super.click()
	if can_attack():
		Controller.attack(lane_idx)
		return
