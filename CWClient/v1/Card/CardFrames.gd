extends Resource
class_name CardFrames

@export var frames: Array = []

var _map = {}

func get_frame(landscape: String, is_creature: bool) -> CompressedTexture2D:
	if landscape not in _map:
		for frame in frames:
			if frame.landscape == landscape:
				_map[landscape] = frame
				break
	if landscape not in _map:
		print('No frame for landscape cards of type: ' + landscape)
		return null
	var result: CardFrame = _map[landscape]
	if is_creature:
		return result.creature_frame
	return result.non_creature_frame
