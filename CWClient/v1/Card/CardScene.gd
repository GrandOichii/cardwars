extends Node2D
class_name CardScene

# !FIXME card name label doesn't shrink with the increase of card name, fix

@export var CardImages: CardImages

@onready var Art: Sprite2D = %Art
@onready var Frame: Sprite2D = %Frame

@onready var CostLabel: Label = %CostLabel
@onready var NameLabel: Label = %NameLabel
@onready var TypeLabel: Label = %TypeLabel
@onready var TextLabel: Label = %TextLabel
@onready var AttackLabel: Label = %AttackLabel
@onready var DefenseLabel: Label = %DefenseLabel
@onready var IDLabel: Label = %IDLabel

var _card_name: String = ''

func _ready():
	pass # Replace with function body.
	
func set_card_name(new_name: String):
	if _card_name == new_name:
		return
	_card_name = new_name
	NameLabel.text = _card_name
	for card in CardImages.cards:
		if card.name == _card_name:
			Art.texture = card.image
			return
	Art.texture = null
	print('Not found art for card ' + _card_name)
	
func load_snapshot(card: Variant):
	set_card_name(card.Name)
	IDLabel.text = card.ID
	CostLabel.text = str(card.Cost)
	TextLabel.text = card.Text
	if card.Type == 'Creature':
		_load_creature(card)

func _load_creature(card: Variant):
	AttackLabel.text = str(card.Attack)
	DefenseLabel.text = str(card.Defense)

# signal connections

func OnArea2dMouseEntered():
	print('mouse enter')

func OnArea2dMouseExited():
	print('mouse leave')
