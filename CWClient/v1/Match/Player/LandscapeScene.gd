extends Control
class_name LandscapeScene

@onready var OrderContainer = %OrderContainer

func _ready():
	pass # Replace with function body.
	
	
func flip_ordering():
	for _i in OrderContainer.get_child_count():
		OrderContainer.move_child(OrderContainer.get_child(_i), 0)
