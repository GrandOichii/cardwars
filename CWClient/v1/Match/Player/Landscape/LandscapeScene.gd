extends Node2D

# !FIXME supports only 1 visible building

@export var landscape_mapping: LandscapeMap

@onready var Art: Sprite2D = %Art
@onready var ReadyCreaturePoint: Node2D = %ReadyCreaturePoint
@onready var AttackingCreaturePoint: Node2D = %AttackingCreaturePoint
@onready var FloopedCreaturePoint: Node2D = %FloopedCreaturePoint
@onready var BuildingPoint: Node2D = %BuildingPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_snapshot(landscape: Variant):
	var landName = landscape.Name
	for res in landscape_mapping.landscapes:
		if landName == res.name and len(res.textures) > 0:
			Art.texture = res.textures[0]
			return
	print('Art not found for ' + landName)
