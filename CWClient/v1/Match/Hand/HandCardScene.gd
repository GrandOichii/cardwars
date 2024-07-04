extends Control
class_name HandCardScene

@onready var Card = %Card
@onready var Bg: ColorRect = %Bg

func _ready():
	pass
	
func load_snapshot(card: Variant):
	Card.load_snapshot(card)
