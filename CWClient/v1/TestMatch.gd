extends Control

@onready var Match = %Match
@onready var Connection = %Connection

func _ready():
	Connection.Connect('127.0.0.1', 9090)
	print('Connected!')

# signal connections

func OnConnectionMessageReceived(message: String):
	print(message)
