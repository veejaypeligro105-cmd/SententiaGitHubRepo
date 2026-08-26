extends Area3D

var player_inside := false

func _on_body_entered(body: Node) -> void:
	# Only trigger for the 3D player
	if body.name == "Player3D":
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player3D":
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("Interact"):
		get_tree().change_scene_to_file("res://Scenes/World2D.tscn")
