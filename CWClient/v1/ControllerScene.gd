extends Node
class_name ControllerScene

signal Update(update: Variant)
signal Response(msg: String)

var last_update: Variant = null

func set_last_update(update: Variant):
	last_update = update
	Update.emit(update)

func can_play(card: Variant) -> bool:
	if last_update.Request != 'PromptAction':
		return false
	return ('p ' + card.ID) in last_update.Args.values()
	
func can_attack(lane_idx: int) -> bool:
	if last_update.Request != 'PickAttackLane':
		return false
	return str(lane_idx) in last_update.Args.values()

func send(msg: String):
	Response.emit(msg)
