extends Control

@onready var Player1: PlayerScene = %Player1
@onready var Player2: PlayerScene = %Player2

# Called when the node enters the scene tree for the first time.
func _ready():
	Player1.PlayerIdx = 0
	Player1.PlayerIdx = 1
	
func set_controller(controller: ControllerScene):
	Player1.set_controller(controller)
	Player2.set_controller(controller)

# signal connections

# !FIXME bad signal name
func OnTestMatchUpdateReceived(update: Variant):
	var players = update.Players
	Player1.load_snapshot(update)
	Player2.load_snapshot(update)

# !FIXME bad signal name
func OnTestMatchMatchInfoReceived(match_info: Variant):
	Player2.load_match_info(match_info)
	Player1.set_player_idx(1 - match_info.PlayerIdx)
