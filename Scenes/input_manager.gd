extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const Collision_card = 1
#const Collision_card_deck = 4
#CARD DECK FUNCTION
var card_manager_reference
#var deck_reference (CARD DECK FUNCTION)


func _ready() -> void:
	card_manager_reference = $"../CardManager"
	#deck_reference = $"../Deck"(CARD DECK FUNCTION)
	
	#CARD DECK FUNCTION
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
			
func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = Collision_card

	var result = space_state.intersect_point(parameters)

	if result.size() > 0:
		var collider = result[0].collider.get_parent()

		if collider:
			card_manager_reference.start_drag(collider)
