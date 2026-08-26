extends Area3D

var entered = false

func _on_body_entered(body: CharacterBody3D) -> void:
	if body.name == "Player":
		entered = true


func _on_body_exited(body: CharacterBody3D) -> void:
	if body.name == "Player":
		entered = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entered:
		if Input.is_action_just_pressed("Interact"):

			# FORCE CURSOR TO SHOW BEFORE SCENE CHANGE
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://Scenes/card_battle_system.tscn")
