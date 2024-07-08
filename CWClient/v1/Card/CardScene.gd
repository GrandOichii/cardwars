extends Node2D
class_name CardScene

# !FIXME card name label doesn't shrink with the increase of card name

signal MouseEnter
signal MouseLeave
signal Click

@export var Images: CardImages
@export var Frames: CardFrames

@onready var Art: Sprite2D = %Art
@onready var Frame: Sprite2D = %Frame

@onready var CostLabel: Label = %CostLabel
@onready var NameLabel: Label = %NameLabel
@onready var TypeLabel: Label = %TypeLabel
@onready var TextLabel: Label = %TextLabel
@onready var AttackLabel: Label = %AttackLabel
@onready var DefenseLabel: Label = %DefenseLabel
@onready var IDLabel: Label = %IDLabel
@onready var DamageLabel: Label = %DamageLabel

@onready var Bg: Polygon2D = %Bg

@export var Behavior: CardBehavior = null

var _card_name: String = ''
var _landscape: String = ''
var _is_creature: bool = false

func _ready():
	if Behavior != null:
		Behavior.set_card(self)
	
func set_card_name(new_name: String):
	if _card_name == new_name:
		return
	_card_name = new_name
	NameLabel.text = _card_name
	Art.texture = Images.get_image(_card_name)
	
func set_landscape(new_landscape: String, is_creature: bool):
	_landscape = new_landscape
	var tex = Frames.get_frame(_landscape, is_creature)
	Frame.texture = tex
	
func load_snapshot(card: Variant):
	var is_creature = card.Type == 'Creature'
	set_card_name(card.Name)
	set_landscape(card.Landscape, is_creature)
	IDLabel.text = card.ID
	CostLabel.text = str(card.Cost)
	TextLabel.text = card.Text
	AttackLabel.visible = false
	DefenseLabel.visible = false
	if is_creature:
		_load_creature(card)

func set_attack(attack: int):
	if attack < 0:
		attack = 0
	AttackLabel.text = str(attack)

func _load_creature(card: Variant):
	AttackLabel.visible = true
	DefenseLabel.visible = true
	set_attack(card.Attack)
	DefenseLabel.text = str(card.Defense)

func load_in_play_snapshot(card: Variant):
	load_snapshot(card)
	# TODO add multiple landscape type display
	if card.Type == 'Creature':
		_load_in_play_creature(card)

func _load_in_play_creature(card: Variant):
	# TODO change label color depending if defense is higher or lower than base
	DefenseLabel.text = str(card.Defense - card.Damage)
	DamageLabel.hide()
	if card.Damage > 0:
		DamageLabel.show()
		DamageLabel.text = str(card.Damage)
	
func set_bg_color(color: Color):
	Bg.color = color

# signal connections

func OnArea2dMouseEntered():
	MouseEnter.emit()

func OnArea2dMouseExited():
	MouseLeave.emit()

func OnArea2dInputEvent(viewport, e, shape_idx):
	if e.is_action_pressed('interact'):
		Click.emit()
