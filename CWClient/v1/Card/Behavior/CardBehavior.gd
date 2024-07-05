extends Resource
class_name CardBehavior

var Card: CardScene
var Controller: ControllerScene

func set_card(card: CardScene):
	Card = card

func set_controller(controller: ControllerScene):
	Controller = controller
	Controller.Update.connect(OnUpdate)

func set_bg_color(color: Color):
	Card.set_bg_color(color)

func mouse_enter():
	pass
	
func mouse_leave():
	pass
	
func click():
	pass

func OnUpdate(update: Variant):
	pass
