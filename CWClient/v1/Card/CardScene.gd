extends Node2D
class_name CardScene

# !FIXME card name label doesn't shrink with the increase of card name, fix

@onready var Art: Sprite2D = %Art
@onready var Frame: Sprite2D = %Frame

@onready var CostLabel: Label = %CostLabel
@onready var NameLabel: Label = %NameLabel
@onready var TypeLabel: Label = %TypeLabel
@onready var TextLabel: Label = %TextLabel
@onready var AttackLabel: Label = %AttackLabel
@onready var DefenseLabel: Label = %DefenseLabel
@onready var IDLabel: Label = %IDLabel

func _ready():
	pass # Replace with function body.

# signal connections

func OnArea2dMouseEntered():
	print('mouse enter')

func OnArea2dMouseExited():
	print('mouse leave')
