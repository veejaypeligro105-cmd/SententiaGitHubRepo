extends CharacterBody2D

@export var enemy_data: EnemyData
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

var player_in_range := false

func _ready():
	add_to_group("npc")
	if is_defeated():
		queue_free()
		return

	anim.play("Idle")

func _process(delta):

	# Press E while near NPC
	if player_in_range and Input.is_action_just_pressed("Interact"):
		interact()

func _on_interaction_area_body_entered(body):

	if body.is_in_group("player"):
		player_in_range = true

func _on_interaction_area_body_exited(body):

	if body.is_in_group("player"):
		player_in_range = false


func restore_world_state():

	var npcs = get_tree().get_nodes_in_group("npc")

	for npc in npcs:
		if npc.enemy_data != null and npc.enemy_data == GameManager.current_enemy:
			npc.queue_free()


func is_defeated() -> bool:
	return enemy_data != null and enemy_data.enemy_id in GameManager.defeated_npc_ids

func interact():

	if enemy_data == null:
		print("No enemy data assigned")
		return

	GameManager.current_enemy = enemy_data
	GameManager.return_scene = get_tree().current_scene.scene_file_path
	GameManager.return_npc_id = enemy_data.enemy_id

	var player = get_tree().get_first_node_in_group("player")

	#if player:
		#GameManager.player_return_position = player.global_position
	
	#THIS SHOWS THE CURSOR IN THE CB
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


	print("Enemy:", enemy_data.enemy_name)

	await get_tree().create_timer(.05).timeout

	SceneManager.goto_scene("res://SAmain_combat_scene.tscn", false)
