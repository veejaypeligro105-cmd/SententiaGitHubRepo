extends Area3D

var entered = false

func _on_body_entered(body: PhysicsBody3D) -> void:
	if body.name == "Player":
		entered = true

func _on_body_exited(body: PhysicsBody3D) -> void:
	if body.name == "Player":
		entered = false
	
func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("Interact"):
			get_tree().change_scene_to_file("res://Scenes/home_lobby_gp.tscn")
