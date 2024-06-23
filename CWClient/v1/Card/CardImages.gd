extends Resource
class_name CardImages


@export var cards: Array

var _map = {}

func get_image(card_name: String) -> CompressedTexture2D:
	if card_name not in _map:
		for card in cards:
			if card.name == card_name:
				_map[card_name] = card
				break
	if card_name not in _map:
		print('Not found art for card ' + card_name)
		return null
	return _map[card_name].image
