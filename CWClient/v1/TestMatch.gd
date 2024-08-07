extends Control

signal UpdateReceived(Variant)
signal MatchInfoReceived(Variant)

@export var start_fullscreen: bool = true
@export var player_name: String = 'RealPlayer'
@export var decks: Array[Deck] = []
@export var seed = 0

@export_group("Connection")
@export var host: String = '127.0.0.1'
@export var port: int = 9090

@export_group("Packed scenes")
@export var HandCardPS: PackedScene

@onready var Match = %Match
@onready var Controller: ControllerScene = %Controller
@onready var Connection = %Connection
@onready var HintLabel = %HintLabel

@onready var ActionEdit = %ActionEdit
@onready var RandomButton = %RandomButton
@onready var OptionsLabel = %OptionsLabel

@onready var HandContainer = %HandContainer

@onready var PickStringWindow = %PickStringWindow
@onready var PickStringText = %PickStringText
@onready var PickStringButtonContainer = %PickStringButtonContainer

@onready var ConnectWindow = %ConnectWindow
@onready var AddressEdit = %AddressEdit
@onready var PortEdit = %PortEdit
@onready var DeckOption = %DeckOption
@onready var PlayerNameEdit = %PlayerNameEdit

@onready var _rng = RandomNumberGenerator.new()

var _update: Variant

func _ready():
	_rng.seed = seed
	if start_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	AddressEdit.text = host
	PortEdit.text = str(port)
	PlayerNameEdit.text = player_name
	for deck in decks:
		DeckOption.add_item(deck.name)
		DeckOption.set_item_metadata(DeckOption.item_count - 1, deck)

func process_update(update: Variant):
	# print(update)
	
	Controller.set_last_update(update)

	HintLabel.text = update.Hint
	var text = ''
	for key in update.Args:
		text += key + ': ' + update.Args[key] + '\n'
	OptionsLabel.text = text
	
	if update.Request == 'PromptLandscapePlacement':
		var landscapes = []
		for key in update.Args:
			for i in int(update.Args[key]):
				landscapes += [key]
		Connection.Write('|'.join(landscapes))
		return
	if update.Request == 'PickOption':
		setup_pick_string(update)
		return
	
	update_hand(update)

func setup_pick_string(update: Variant):
	PickStringText.text = update.Hint
	PickStringWindow.show()
	while (PickStringButtonContainer.get_child_count() > 0):
		PickStringButtonContainer.remove_child(PickStringButtonContainer.get_child(0))
	for option in update.Args.values():
		var b = Button.new()
		PickStringButtonContainer.add_child(b)
		b.text = option
		var action = func():
			Connection.Write(option)
			PickStringWindow.hide()
		b.pressed.connect(action)
	
func update_hand(update: Variant):
	var newCount = len(update.Personal.Hand)
	while (HandContainer.get_child_count() < newCount):
		var child = HandCardPS.instantiate()
		HandContainer.add_child(child)
		var cardScene = child as HandCardScene
		cardScene.set_controller(Controller)
	while (HandContainer.get_child_count() > newCount):
		HandContainer.remove_child(HandContainer.get_child(0))
	for i in newCount:
		var card = update.Personal.Hand[i]
		var cardScene = HandContainer.get_child(i) as HandCardScene
		cardScene.set_hand_idx(i)
		cardScene.load_snapshot(card)
	
func process_match_info(match_info: Variant):
	Controller.set_match_info(match_info)
	print(match_info)

# signal connections

func OnConnectionMessageReceived(message: String):
	var json = JSON.new()
	var error = json.parse(message)
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", message, " at line ", json.get_error_line())
		return
	var data = json.data
	if 'Request' in data:
		_update = data
		process_update(data)
		UpdateReceived.emit(data)
		return
	process_match_info(data)
	MatchInfoReceived.emit(data)

func OnSendActionButtonPressed():
	Connection.Write(ActionEdit.text)
	ActionEdit.text = ''
	
func OnFightButtonPressed():
	Connection.Write('f')

func OnRandomButtonPressed():
	if _update.Request == 'PromptAction':
		var choices = _update.Args.values()
		var choice = choices[_rng.randi() % len(choices)]
		Connection.Write(choice)
		return

func OnControllerResponse(msg: String):
	Connection.Write(msg)

func OnDrawButtonPressed():
	Connection.Write('d')

func OnConnectionConnected():
	Connection.Write(PlayerNameEdit.text)
	var deck = DeckOption.get_selected_metadata()
	Connection.Write(deck.to_json())
	ConnectWindow.hide()
	Match.show()

func OnConnectButtonPressed():
	Connection.Connect(AddressEdit.text, int(PortEdit.text))
	Match.set_controller(Controller)

func OnConnectWindowCloseRequested():
	get_tree().quit()
