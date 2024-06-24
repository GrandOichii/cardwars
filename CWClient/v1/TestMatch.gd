extends Control

signal UpdateReceived(Variant)
signal MatchInfoReceived(Variant)

@export var seed = 0

@export_group("Connection")
@export var host: String = '127.0.0.1'
@export var port: int = 9090

@export_group("Landscapes")
@export_enum("Blue Plains", "Cornfield", "IcyLands", "NiceLands", "SandyLands", "Useless Swamp") var landscape1 = "Blue Plains"
@export_enum("Blue Plains", "Cornfield", "IcyLands", "NiceLands", "SandyLands", "Useless Swamp") var landscape2 = "Blue Plains"
@export_enum("Blue Plains", "Cornfield", "IcyLands", "NiceLands", "SandyLands", "Useless Swamp") var landscape3 = "Blue Plains"
@export_enum("Blue Plains", "Cornfield", "IcyLands", "NiceLands", "SandyLands", "Useless Swamp") var landscape4 = "Blue Plains"

@onready var Match = %Match
@onready var Connection = %Connection
@onready var HintLabel = %HintLabel

@onready var ActionEdit = %ActionEdit
@onready var RandomButton = %RandomButton

@onready var _rng = RandomNumberGenerator.new()

var _update: Variant

func _ready():
	_rng.seed = seed
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	Connection.Connect(host, port)

func process_update(update: Variant):
	# print(update)

	HintLabel.text = update.Hint
	if update.Request == 'PromptLandscapePlacement':
		Connection.Write(landscape1 + '|' + landscape2 + '|' + landscape3 + '|' + landscape4)
		return
	
func process_match_info(match_info: Variant):
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
