extends Node
class_name ControllerScene

# TODO
# PickBuilding
# PickCard
# PickCardInDiscard
# PickCardInHand
# PickPlayer
# * PromptAction - activated abilities, remove frozen tokens
# PromptLandscapePlacement

signal Update(update: Variant)
signal Response(msg: String)

var match_info: Variant = null
var last_update: Variant = null

func _input(e):
	if e.is_action_pressed('fight'):
		# TODO add checks
		send('f')

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

func can_pick_landscape(player_idx: int, lane_idx) -> bool:
	if last_update.Request != 'PickLandscape':
		return false
	var my_idx = match_info.PlayerIdx
	var opp_idx = 1 - my_idx
	if my_idx == 1:
		player_idx = 1 - player_idx
	for key in last_update.Args:
		var value = last_update.Args[key]
		if value != str(lane_idx):
			continue
		return player_idx != opp_idx or key[0] == 'o'
	return false

func pick_landscape(player_idx: int, lane_idx: int):
	if match_info.PlayerIdx == 1:
		player_idx = 1 - player_idx
	send(str(player_idx) + ' ' + str(lane_idx))
	
func can_activate(in_play_card: Variant) -> bool:
	if last_update.Request != 'PromptAction':
		return false
	var values = last_update.Args.values()
	for v in values:
		if v.begins_with('a ' + str(in_play_card.ID) + ' '):
			return true
	return false
	
func activate(in_play_card: Variant):
	# !FIXME only activates the first ability of card
	send('a ' + str(in_play_card.ID) + ' 0')
	
func can_pick_card_in_hand(hand_idx: int) -> bool:
	if last_update.Request != 'PickCardInHand':
		return false
	return str(hand_idx) in last_update.Args.values()
	
func pick_card_in_hand(hand_idx: int):
	send(str(hand_idx))

func can_pick_card_in_discard(player_idx: int, discard_idx: int) -> bool:
	if last_update.Request != 'PickCardInDiscard':
		return false
	var my_idx = match_info.PlayerIdx
	var opp_idx = 1 - my_idx
	if my_idx == 1:
		player_idx = 1 - player_idx
	for key in last_update.Args:
		var value = last_update.Args[key]
		if value != str(discard_idx):
			continue
		if key[0] == 'o' && player_idx != opp_idx:
			continue
		return true
	return false
	
func pick_card_in_discard(player_idx: int, discard_idx: int):
	if match_info.PlayerIdx == 1:
		player_idx = 1 - player_idx
	send(str(player_idx) + ' ' + str(discard_idx))
	
func can_remove_frozen_token(lane_idx: int):
	if last_update.Request != 'PromptAction':
		return false
	return ('rf ' + str(lane_idx)) in last_update.Args.values()
	
func remove_frozen_token(lane_idx: int):
	send('rf ' + str(lane_idx))

func send(msg: String):
	Response.emit(msg)
