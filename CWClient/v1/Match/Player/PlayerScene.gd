extends Control
class_name PlayerScene

@export_file("*.tscn") var landscape_packed_scene: String = ''
@export var ordering_flipped: bool = false

@export_group('Packed Scenes')
@export var DiscardCardPS: PackedScene

@onready var InfoContainer = %InfoContainer
@onready var NameLabel = %NameLabel
@onready var LifeLabel = %LifeLabel
@onready var ActionPointsLabel = %ActionPointsLabel
@onready var RestrictedActionPointsLabel = %RestrictedActionPointsLabel
@onready var HandSizeLabel = %HandSizeLabel
@onready var DiscardCountLabel = %DiscardCountLabel
@onready var DeckCountLabel = %DeckCountLabel

@onready var Landscapes: Node2D = %Landscapes

@onready var DiscardWindow = %DiscardWindow
@onready var DiscardPileCardContainer = %DiscardPileCardContainer

var PlayerIdx: int
var Controller: ControllerScene = null

func _ready():
	pass

func set_controller(controller: ControllerScene):
	Controller = controller
	for landscape: LandscapeScene in Landscapes.get_children():
		landscape.set_controller(controller)
	for card: DiscardCardScene in DiscardPileCardContainer.get_children():
		card.set_controller(controller)

func load_match_info(match_info: Variant):
	set_player_idx(match_info.PlayerIdx)
		
	#for i in config.
	
func set_player_idx(new_idx: int):
	PlayerIdx = new_idx
	var idx = 0
	# TODO
	DiscardWindow.title = 'Discard pile of player [' + str(PlayerIdx) + ']'
	for landscape: LandscapeScene in Landscapes.get_children():
		landscape.set_player_idx(new_idx)
		landscape.set_lane_idx(idx)
		idx += 1
	if ordering_flipped:
		flip_ordering()
		for landscape: LandscapeScene in Landscapes.get_children():
			# TODO bad
			landscape.lane_idx = 3 - landscape.lane_idx
	
func flip_ordering():
	for _i in InfoContainer.get_child_count():
		InfoContainer.move_child(InfoContainer.get_child(_i), 0)
	
	# landscapes
	Landscapes.rotation = PI

func load_snapshot(snapshot: Variant):
	if len(snapshot.Players) == 0:
		return
	var player = snapshot.Players[PlayerIdx]
	NameLabel.text = player.Name
	if PlayerIdx == snapshot.CurPlayerIdx:
		NameLabel.text = '> ' + player.Name
	LifeLabel.text = str(player.Life)
	ActionPointsLabel.text = str(player.ActionPoints)
	RestrictedActionPointsLabel.text = ''
	if player.RestrictedActionPoints > 0:
		RestrictedActionPointsLabel.text = ' + ' + str(player.RestrictedActionPoints)
	HandSizeLabel.text = str(player.HandCount)
	DeckCountLabel.text = str(player.DeckCount)
	DiscardCountLabel.text = str(len(player.DiscardPile))
	
	for landscape: LandscapeScene in Landscapes.get_children():
		landscape.load_snapshot(snapshot)
	_load_discard_pile(snapshot)
	
func _load_discard_pile(snapshot: Variant):
	var player = snapshot.Players[PlayerIdx]
	var newCount = len(player.DiscardPile)
	while (DiscardPileCardContainer.get_child_count() < newCount):
		var child = DiscardCardPS.instantiate()
		DiscardPileCardContainer.add_child(child)
		var cardScene = child as DiscardCardScene
		cardScene.set_controller(Controller)
		cardScene.set_player_idx(PlayerIdx)
	while (DiscardPileCardContainer.get_child_count() > newCount):
		DiscardPileCardContainer.remove_child(DiscardPileCardContainer.get_child(0))
	for i in newCount:
		var card = player.DiscardPile[i]
		var cardScene = DiscardPileCardContainer.get_child(i) as DiscardCardScene
		cardScene.set_discard_idx(i)
		cardScene.load_snapshot(card)

func OnDiscardImagePressed():
	print('PRESS')
	DiscardWindow.show()

func OnDiscardWindowCloseRequested():
	DiscardWindow.hide()
