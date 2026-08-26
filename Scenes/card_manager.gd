extends Node2D

#watch 

@onready var card_slot = $"../cardSlot"

const Collision_card = 1
const Collision_card_slot = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1

var cardDrag
var screen_size
var is_hovering_on_card
var player_hand_reference

func _ready() -> void:
	add_to_group("card_manager")
	randomize()

	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"

	$"../InputManager".connect("left_mouse_button_clicked", on_left_click_release)

# 🔥 SPAWN CARDS BASED ON QUESTION
func spawn_question_cards(question):
	var card_scene = preload("res://Scenes/card.tscn")

	var choices = question["choices"]
	var correct = question["correct_card"]

	for i in range(choices.size()):
		var new_card = card_scene.instantiate()

		new_card.choice_text = choices[i]
		new_card.is_correct = (choices[i] == correct)

		new_card.update_card_visual()

		add_child(new_card)
		connect_grid_signal(new_card)

		player_hand_reference.add_card_to_hand(new_card, 0.1)

func remove_card_from_slot(card):
	if card == null or not is_instance_valid(card):
		return

	var tween = get_tree().create_tween()
	tween.tween_property(card, "scale", Vector2(0,0), 0.2)

	await tween.finished

	if is_instance_valid(card):
		card.queue_free()

	card_slot.remove_card()

func _process(delta: float) -> void:
	if cardDrag:
		var mouse_pos = get_global_mouse_position()
		cardDrag.position = mouse_pos

func start_drag(card):
	cardDrag = card
	card.scale = Vector2(1, 1)
	card.z_index = 10

func finish_drag():
	cardDrag.scale = Vector2(1.05, 1.05)

	var card_slot_found = raycast_check_for_card_slot()

	if card_slot_found and not card_slot_found.card_in_slot:
		player_hand_reference.remove_card_from_hand(cardDrag)

		cardDrag.position = card_slot_found.global_position
		cardDrag.get_node("Area2D/CollisionShape2D").disabled = true

		card_slot_found.place_card(cardDrag)
	else:
		player_hand_reference.add_card_to_hand(cardDrag, DEFAULT_CARD_MOVE_SPEED)

	cardDrag = null

func remove_one_wrong_card() -> bool:
	var wrong_cards = []
	
	for card in player_hand_reference.player_hand:
		if not card.is_correct:
			wrong_cards.append(card)
		
	if wrong_cards.size() == 0:
		return false
		
	var card_to_remove = wrong_cards.pick_random()
	
	player_hand_reference.remove_card_from_hand(card_to_remove)
	card_to_remove.queue_free()
	
	return true



func connect_grid_signal(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_left_click_release():
	if cardDrag:
		finish_drag()

func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
	highlight_card(card, true)

func on_hovered_off_card(card):
	if !cardDrag:
		highlight_card(card, false)
		is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
	else:
		card.scale = Vector2(1, 1)

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()

	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = Collision_card_slot

	var result = space_state.intersect_point(parameters)

	if result.size() > 0:
		return result[0].collider.get_parent()

	return null

# 🔥 RESET ONLY (NO AUTO SPAWN)
func reset_cards():
	for card in get_children():
		if card.is_in_group("card"):
			card.queue_free()

	player_hand_reference.player_hand.clear()
