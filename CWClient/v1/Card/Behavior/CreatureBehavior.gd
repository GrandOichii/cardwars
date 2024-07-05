extends InPlayCardBehavior
class_name CreatureBehavior

@export var lane_idx: int

@export_group('Colors')
@export var CanAttackColor: Color
@export var AttackHoverColor: Color

func can_attack() -> bool:
	return Controller.can_attack(lane_idx)

func mouse_enter():
	super.mouse_enter()
	if can_attack():
		set_bg_color(AttackHoverColor)
		return
	
func click():
	super.click()
	if can_attack():
		Controller.send(str(lane_idx))
		return
