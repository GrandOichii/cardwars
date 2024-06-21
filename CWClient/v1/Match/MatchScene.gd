extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# signal connections

func OnTestMatchUpdateReceived(update: Variant):
	print(update.Request)
