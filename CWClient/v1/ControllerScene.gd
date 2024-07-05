extends Node
class_name ControllerScene

signal Update(update: Variant)
signal Response(msg: String)

var match_info: Variant = null
var last_update: Variant = null

func set_last_update(update: Variant):
	last_update = update
	Update.emit(update)

func can_play(card: Variant) -> bool:
	if last_update.Request != 'PromptAction':
		return false
	return ('p ' + card.ID) in last_update.Args.values()
	
func play(card: Variant):
	send('p ' + card.ID)
	
func can_attack(lane_idx: int) -> bool:
	if last_update.Request != 'PickAttackLane':
		return false
	return str(lane_idx) in last_update.Args.values()
	
func attack(lane_idx: int):
	send(str(lane_idx))
	
func can_pick_lane_for_creature(player_idx: int, lane_idx: int) -> bool:
	print(last_update.Request)
	if last_update.Request != 'PickLaneForCreature':
		return false
	return str(lane_idx) in last_update.Args.values()
	
func pick_lane_for_creature(lane_idx: int):
	send(str(lane_idx))

func send(msg: String):
	Response.emit(msg)
