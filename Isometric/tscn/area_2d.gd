extends Area2D

var entered := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("Interact"):
		SceneManager.goto_scene("res://Scenes/home_lobby_gp.tscn", true)


func _on_body_entered(body: PhysicsBody2D) -> void:
	entered = true

func _on_body_exited(body: PhysicsBody2D) -> void:
	entered = false
