extends Area3D

var entered = false

var can_interact := false

func _process(delta: float) -> void:
	if entered == true:
		if entered and Input.is_action_just_pressed("Interact"):
			get_tree().change_scene_to_file("res://InsideSchool/inside_school.tscn")
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		entered = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		entered = false
