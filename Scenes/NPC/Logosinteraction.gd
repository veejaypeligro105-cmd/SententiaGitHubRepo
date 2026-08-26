extends Area3D

var entered := false
var npc = null

func _ready():
	npc = get_parent()


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		entered = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		entered = false


func _process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("Interact"):
		if npc and npc.has_method("interact"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			npc.interact()
