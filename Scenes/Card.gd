extends Node2D

signal hovered
signal hovered_off

var position_in_hand: Vector2 = Vector2.ZERO
var hovered_slot: Node2D = null

@onready var card_image = $CardImage
@onready var card_label = $Cardlabel

var choice_text = ""
var is_correct = false


func _ready() -> void:
	await get_tree().process_frame
	add_to_group("card")
	update_card_visual()
	setup_label()


func update_card_visual():
	if card_image == null:
		return

	card_image.texture = load("res://Scenes/CardDeck/Card.png")
	card_label.text = choice_text


func setup_label():
	card_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	card_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# SAFE FONT SIZE 
	card_label.add_theme_font_size_override("font_size", 12.5)

# SNAP SYSTEM
func snap_to_slot(slot: Node2D) -> void:
	if slot == null:
		return

	var snap_point = slot.get_node("SnapPoint")
	global_position = snap_point.global_position


func _process(_delta: float) -> void:
	if hovered_slot and Input.is_action_just_released("mouse_left"):
		snap_to_slot(hovered_slot)



# HOVER SIGNALS
func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
