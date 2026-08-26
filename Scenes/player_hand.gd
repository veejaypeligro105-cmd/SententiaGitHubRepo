extends Node2D

#Should i Add Deck of cards? or not
#if yes watch and implement this (https://www.youtube.com/watch?v=riafP7MtvmQ)

#(For part 6 for Animation of cards (https://www.youtube.com/watch?v=L1dEuHr5AGU&list=PLNWIwxsLZ-LMYzxHlVb7v5Xo5KaUV7Tq1&index=6)
#didnt finish because of the assets)

const CARD_WIDTH = 100	#card spaces
const HAND_Y_POSITION = 575 	#card Horizontal Position
const DEFAULT_CARD_MOVE_SPEED = 0.1

var player_hand = []
var center_screen_x
var tween = create_tween()


func _ready() -> void:
	await get_tree().process_frame
	center_screen_x = get_viewport_rect().size.x / 2

	await get_tree().process_frame

func add_card_to_hand(card, speed):
	card.get_node("Area2D/CollisionShape2D").disabled = false
	if card not in player_hand:
		player_hand.append(card)
		update_hand_position(speed)
	else:
		animate_card_to_position(card,card.position_in_hand, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_position(speed):
	var count = player_hand.size()
	if count == 0:
		return

	var viewport_size = get_viewport_rect().size
	var center_x = viewport_size.x * 0.5

	var total_width = (count - 1) * CARD_WIDTH

	for i in range(count):
		var card = player_hand[i]

		var x = center_x + (i * CARD_WIDTH) - (total_width / 2)
		var new_position = Vector2(x, HAND_Y_POSITION)

		card.position_in_hand = new_position
		animate_card_to_position(card, new_position, speed)

func calculate_card_position(index):
	var viewport_size = get_viewport_rect().size
	var safe_center = viewport_size.x * 0.5

	if player_hand.size() <= 1:	
		return safe_center

	var total_width = float(player_hand.size() - 1) * float(CARD_WIDTH)

	return safe_center + float(index) * float(CARD_WIDTH) - total_width / 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card, new_position, speed):
	var tween = create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position(DEFAULT_CARD_MOVE_SPEED)
