extends Node
class_name ControllerScene

# TODO
# PickBuilding
# PickCard
# PickCardInDiscard
# PickCardInHand
# PickCreature
# PickLandscape
# PickOption
# PickPlayer
# * PromptAction
# PromptLandscapePlacement

signal Update(update: Variant)
signal Response(msg: String)

var match_info: Variant = null
var last_update: Variant = null

func set_last_update(update: Variant):
	last_update = update
	Update.emit(update)

func set_match_info(info: Variant):
	match_info = info

func can_play(card: Variant) -> bool:
	if last_update.Request != 'PromptAction':
		return false
	return ('p ' + card.ID) in last_update.Args.values()
	
func play(card: Variant):
	send('p ' + card.ID)
	
func can_attack(player_idx: int, lane_idx: int) -> bool:
	# !FIXME last_update is null sometimes on boot
	if last_update.Request != 'PickAttackLane':
		return false
	return player_idx == match_info.PlayerIdx and str(lane_idx) in last_update.Args.values()
	
func attack(lane_idx: int):
	send(str(lane_idx))
	
func can_pick_lane_for_creature(player_idx: int, lane_idx: int) -> bool:
	if last_update.Request != 'PickLaneForCreature':
		return false
	return player_idx == match_info.PlayerIdx and str(lane_idx) in last_update.Args.values()

func pick_lane_for_creature(lane_idx: int):
	send(str(lane_idx))
	
func can_pick_lane_for_building(player_idx: int, lane_idx: int) -> bool:
	if last_update.Request != 'PickLaneForBuilding':
		return false
	return player_idx == match_info.PlayerIdx and str(lane_idx) in last_update.Args.values()

func pick_lane_for_building(lane_idx: int):
	send(str(lane_idx))

func can_pick_creature(card: Variant):
	if last_update.Request != 'PickCreature':
		return false
	return card.ID in last_update.Args.values()

func pick_creature(card: Variant):
	send(str(card.ID))

func can_pick_lane(player_idx: int, lane_idx: int) -> bool:
	if last_update.Request != 'PickLane':
		return false
	return player_idx == match_info.PlayerIdx and str(lane_idx) in last_update.Args.values()

func pick_lane(lane_idx: int):
	send(str(lane_idx))


func send(msg: String):
	Response.emit(msg)
