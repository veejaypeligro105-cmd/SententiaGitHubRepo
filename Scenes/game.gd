extends Node3D

@export var move_speed: float = 1
@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D

func _ready() -> void:
	path_follow.progress_ratio = 0.0

func _physics_process(delta: float) -> void:
	path_follow.progress_ratio += move_speed * delta
	
	if path_follow.progress_ratio >= 1.0:
		path_follow.progress_ratio = 0.0
