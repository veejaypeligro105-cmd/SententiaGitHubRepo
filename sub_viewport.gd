extends SubViewport

@onready var player: CharacterBody3D = $"../../../Player"
@onready var camera_3d: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_3d = get_tree().root.world_3d

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	camera_3d.global_position = player.global_position + Vector3(0, 4.242, 0)
