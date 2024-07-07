extends Resource
class_name Deck

@export var name: String = ''
@export var cards: Array[DeckCard] = []
@export var landscapes: Array[DeckLandscape]

func to_json() -> String:
	var result = {}
	result.Name = name
	var landscapeData = {}
	for landscape in landscapes:
		landscapeData[landscape.landscape] = landscape.amount
	result.Landscapes = landscapeData
	var cardData = {}
	for card in cards:
		cardData[card.card] = card.amount
	result.Cards = cardData
	return JSON.stringify(result)

