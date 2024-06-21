extends Control

@export_file("*.tscn") var landscape_packed_scene: String = ''

@onready var InfoContainer = %InfoContainer
@onready var NameLabel = %NameLabel
@onready var LifeLabel = %LifeLabel
@onready var ActionPointsLabel = %ActionPointsLabel
@onready var RestrictedActionPointsLabel = %RestrictedActionPointsLabel
@onready var HandSizeLabel = %HandSizeLabel
@onready var DiscardCountLabel = %DiscardCountLabel
@onready var DeckCountLabel = %DeckCountLabel
@onready var LandscapeContainer = %LandscapeContainer

var PlayerIdx: int

func _ready():
	pass # Replace with function body.
	
func load_config(config: Variant):
	if config.PlayerIdx == 1:
		flip_ordering()
		
	#for i in config.
	
func flip_ordering():
	# infoLoadSnapshot
	for _i in InfoContainer.get_child_count():
		InfoContainer.move_child(InfoContainer.get_child(_i), 0)
	
	# landscapes
	#TODO

func load_snapshot(snapshot: Variant):
	if len(snapshot.Players) == 0:
		return
	var player = snapshot.Players[PlayerIdx]
	NameLabel.text = player.Name
	LifeLabel.text = str(player.Life)
	ActionPointsLabel.text = str(player.ActionPoints)
	RestrictedActionPointsLabel.text = ''
	if player.RestrictedActionPoints > 0:
		RestrictedActionPointsLabel.text = ' + ' + str(player.RestrictedActionPoints)
	HandSizeLabel.text = str(player.HandCount)
	DeckCountLabel.text = str(player.DeckCount)
