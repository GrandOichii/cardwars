extends Node2D
class_name LandscapeScene

# !FIXME supports only 1 visible building

@export var landscape_mapping: LandscapeMap

@export_group('Colors')
@export var DefaultColor: Color
@export var LanePickColor: Color
@export var LanePickHoverColor: Color

@onready var Art: Sprite2D = %Art
@onready var ReadyCreaturePoint: Node2D = %ReadyCreaturePoint
@onready var AttackingCreaturePoint: Node2D = %AttackingCreaturePoint
@onready var FloopedCreaturePoint: Node2D = %FloopedCreaturePoint
@onready var BuildingPoint: Node2D = %BuildingPoint
@onready var Bg: Polygon2D = %Bg

# for testing now
@onready var CreatureCard: CardScene = %Creature
@onready var BuildingCard: CardScene = %Building

var player_idx: int = -1
var lane_idx: int = -1

var _landscape_name = ''
var _controller: ControllerScene
@onready var _bg_color = DefaultColor

func _ready():
	pass
	
func set_lane_idx(idx: int):
	lane_idx = idx
	CreatureCard.Behavior.lane_idx = idx

func set_player_idx(idx: int):
	player_idx = idx
	CreatureCard.Behavior.player_idx = idx
	
func set_controller(controller: ControllerScene):
	_controller = controller
	_controller.Update.connect(OnUpdate)
	CreatureCard.Behavior.set_controller(controller)
	BuildingCard.Behavior.set_controller(controller)
	
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
	CreatureCard.Behavior.load_snapshot(landscape.Creature)

	# TODO add smooth transitions
	reparent_creature(CreatureCard, ReadyCreaturePoint)
	if creature.Status == 2:
		reparent_creature(CreatureCard, FloopedCreaturePoint)
		return
	if creature.Status == 3:
		reparent_creature(CreatureCard, AttackingCreaturePoint)
		return

func load_buildings(landscape: Variant):
	if len(landscape.Buildings) == 0:
		BuildingCard.visible = false
		return
	var building = landscape.Buildings[0]
	BuildingCard.visible = true
	BuildingCard.load_in_play_snapshot(building)
	BuildingCard.Behavior.load_snapshot(landscape.Buildings[0])

	# TODO add smooth transition
	if building.Status == 2:
		BuildingCard.rotation = PI / 2
	else:
		BuildingCard.rotation = 0

func load_snapshot(snapshot: Variant):
	if player_idx == -1: return
	var landscape = snapshot.Players[player_idx].Landscapes[lane_idx]
	load_creature(landscape)
	load_buildings(landscape)

	# load art
	_set_landscape_name(landscape.Name, landscape.Idx)

	Art.visible = !landscape.FaceDown
	
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

func interact():
	if can_pick_lane_for_creature():
		_controller.pick_lane_for_creature(lane_idx)
		return
	
func can_pick_lane_for_creature():
	return _controller.can_pick_lane_for_creature(player_idx, lane_idx)

func set_bg_color(color: Color):
	Bg.color = color

# signal connections

func OnUpdate(update: Variant):
	_bg_color = DefaultColor
	if can_pick_lane_for_creature():
		_bg_color = LanePickColor
	set_bg_color(_bg_color)

func OnCreatureMouseEnter():
	CreatureCard.Behavior.mouse_enter()

func OnCreatureMouseLeave():
	CreatureCard.Behavior.mouse_leave()

func OnCreatureClick():
	CreatureCard.Behavior.click()

func OnControlMouseEntered():
	if can_pick_lane_for_creature():
		set_bg_color(LanePickHoverColor)
		return

func OnControlMouseExited():
	set_bg_color(_bg_color)

func OnControlGuiInput(e):
	if e.is_action_pressed('interact'):
		interact()
