extends Control

signal UpdateReceived(Variant)
signal MatchInfoReceived(Variant)

@onready var Match = %Match
@onready var Connection = %Connection
@onready var HintLabel = %HintLabel

@onready var ActionEdit = %ActionEdit

func _ready():
	Connection.Connect('127.0.0.1', 9090)

func process_update(update: Variant):
	HintLabel.text = update.Hint
	if update.Request == 'PromptLandscapePlacement':
		Connection.Write('Cornfield Cornfield SandyLands Cornfield')
		return
	print(update.Request)
	
func process_match_info(match_info: Variant):
	pass

# signal connections

func OnConnectionMessageReceived(message: String):
	var json = JSON.new()
	var error = json.parse(message)
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", message, " at line ", json.get_error_line())
		return
	var data = json.data
	if 'Request' in data:
		process_update(data)
		UpdateReceived.emit(data)
		return
	process_match_info(data)
	MatchInfoReceived.emit(data)

func OnSendActionButtonPressed():
	Connection.Write(ActionEdit.text)
	ActionEdit.text = ''
	
