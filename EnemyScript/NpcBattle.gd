extends Area3D

var entered := false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		entered = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		entered = false


func _process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("Interact"):
		var npc = get_parent()

		if npc.has_method("interact"):
			npc.interact()
