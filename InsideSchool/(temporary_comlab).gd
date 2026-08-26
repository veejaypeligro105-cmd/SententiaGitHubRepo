extends Area3D

var entered = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entered == true:
		if Input.is_action_just_pressed("Interact"):
			get_tree().change_scene_to_file("res://Ruined Computer Laboratory/ruined_computer_laboratory.tscn")

func _on_body_entered(body: PhysicsBody3D) -> void:
	if body.name == "Player":
		entered = true

func _on_body_exited(body: PhysicsBody3D) -> void:
	if body.name == "Player":
		entered = false
