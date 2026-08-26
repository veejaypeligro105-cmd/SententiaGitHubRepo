extends CharacterBody2D

const SPEED = 150

@onready var pause_menu = null
@onready var InventoryUI = null

@onready var animated_sprite = $"Player 2D Animation"

var current_animation := ""
var is_in_dialogue := false
var is_inventory_open := false

func _physics_process(delta: float) -> void:
	if get_tree().paused:
		return

	if is_in_dialogue or is_inventory_open:
		velocity = Vector2.ZERO
	else:
		var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
		velocity = input_dir * SPEED
		_update_animation(input_dir)
	move_and_slide()

func _ready():
	add_to_group("player")
	pause_menu = get_tree().get_first_node_in_group("pause_menu")
	InventoryUI = get_tree().get_first_node_in_group("InventoryUI")

	for n in get_tree().get_nodes_in_group("pause_menu"):
		print(n.name, " (", n.get_class(), ") -> ", n.get_path())
		
	# --- DEBUG: print every node in the group and its full path ---
	for n in get_tree().get_nodes_in_group("InventoryUI"):
		print(n.name, " -> ", n.get_path())
	# --- END DEBUG ---
	if InventoryUI:
		InventoryUI.inventory_closed.connect(_on_inventory_closed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()
	if event.is_action_pressed("Inventory"):
		toggle_inventory()

func toggle_inventory():
	is_inventory_open = !is_inventory_open
	InventoryUI.visible = is_inventory_open
	get_tree().paused = is_inventory_open
	Input.set_mouse_mode(
		Input.MOUSE_MODE_VISIBLE if is_inventory_open else Input.MOUSE_MODE_CAPTURED
	)

func _on_inventory_closed() -> void:
	is_inventory_open = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func toggle_pause_menu():
	if get_tree().paused:
		get_tree().paused = false
		pause_menu.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		get_tree().paused = true
		pause_menu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _update_animation(input_dir: Vector2):
	if not animated_sprite:
		return
	var anim_to_play := "Idle-2D"
	if input_dir != Vector2.ZERO:
		if abs(input_dir.x) > abs(input_dir.y):
			anim_to_play = "Walk-2D-Left-Right"
			animated_sprite.flip_h = input_dir.x < 0
		elif input_dir.y > 0:
			anim_to_play = "Walk-2D-Down"
		elif input_dir.y < 0:
			anim_to_play = "Walk-2D-Up"
	if current_animation != anim_to_play:
		current_animation = anim_to_play
		animated_sprite.animation = current_animation
		animated_sprite.play()
