extends Control
class_name PlayerScene

# exports
@export var is_opponent_initial = false

# nodes
@onready var InfoContainer = %InfoContainer
@onready var PlayerNameLabel = %PlayerNameLabel
@onready var LandscapesContainer = %LandscapeContainer

func _ready():
	PlayerNameLabel.text = 'amogus'
	
	if is_opponent_initial:
		flip_ordering()

func flip_ordering():
	# reorder info container
	for _i in InfoContainer.get_child_count():
		InfoContainer.move_child(InfoContainer.get_child(_i), 0)
		
	# reorder landscapes
	for landscape: LandscapeScene in LandscapesContainer.get_children():
		landscape.flip_ordering()
