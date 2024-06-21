extends Control

@onready var Player1 = %Player1
@onready var Player2 = %Player2

# Called when the node enters the scene tree for the first time.
func _ready():
	Player1.PlayerIdx = 0
	Player1.PlayerIdx = 1

# signal connections

func OnTestMatchUpdateReceived(update: Variant):
	var players = update.Players
	Player1.load_snapshot(update)
	Player2.load_snapshot(update)
