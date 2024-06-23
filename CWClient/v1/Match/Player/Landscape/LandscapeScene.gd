extends Node2D

# !FIXME supports only 1 visible building

@export var landscape_mapping: LandscapeMap

@onready var Art: Sprite2D = %Art
@onready var ReadyCreaturePoint: Node2D = %ReadyCreaturePoint
@onready var AttackingCreaturePoint: Node2D = %AttackingCreaturePoint
@onready var FloopedCreaturePoint: Node2D = %FloopedCreaturePoint
@onready var BuildingPoint: Node2D = %BuildingPoint

# for testing now
@onready var CreatureCard: CardScene = %Creature
@onready var BuildingCard: CardScene = %Building

var _landscape_name = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func reparent_creature(creature: CardScene, point: Node2D):
	creature.reparent(point, false)
	creature.position = Vector2.ZERO

func load_creature(landscape: Variant):
	var creature = landscape.Creature
	if creature == null:
		CreatureCard.visible = false
		return
	CreatureCard.visible = true
	CreatureCard.load_in_play_snapshot(landscape.Creature)

	# TODO add smooth transitions
	reparent_creature(CreatureCard, ReadyCreaturePoint)
	if creature.Flooped:
		reparent_creature(CreatureCard, FloopedCreaturePoint)
		return
	if creature.ExhaustedToAttack:
		reparent_creature(CreatureCard, AttackingCreaturePoint)
		return

func load_buildings(landscape: Variant):
	if len(landscape.Buildings) == 0:
		BuildingCard.visible = false
		return
	var building = landscape.Buildings[0]
	BuildingCard.visible = true
	BuildingCard.load_in_play_snapshot(building)
	# TODO add smooth transition
	if building.Flooped:
		BuildingCard.rotation = PI / 2
	else:
		BuildingCard.rotation = 0

func load_snapshot(landscape: Variant):
	load_creature(landscape)
	load_buildings(landscape)

	# load art
	_set_landscape_name(landscape.Name, landscape.Idx)
	
func _set_landscape_name(new_name: String, idx: int):
	if _landscape_name == new_name:
		return
	_landscape_name = new_name
	var rng = RandomNumberGenerator.new()
	for res in landscape_mapping.landscapes:
		if _landscape_name == res.name and len(res.textures) > 0:
			if idx >= len(res.textures):
				idx = rng.randi() % len(res.textures)
			Art.texture = res.textures[idx]
			return
		print('Art not found for ' + _landscape_name)
