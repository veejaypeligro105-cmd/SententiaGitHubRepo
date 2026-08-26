extends Area2D

var entered := false

func _on_body_entered(body: PhysicsBody2D) -> void:
	entered = true

func _on_body_exited(body: PhysicsBody2D) -> void:
	entered = false

func _process(delta):
	if entered and Input.is_action_just_pressed("Interact"):
		SceneManager.goto_scene("res://Isometric/tscn/road.tscn", false)
