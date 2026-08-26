extends Area3D

var entered = false


func _ready() -> void:
	pass
	
	
func _process(_delta: float) -> void:
	if entered == true:
		if Input.is_action_just_pressed("Interact"):
			get_tree().change_scene_to_file("res://world.tscn")


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		entered = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		entered = false
