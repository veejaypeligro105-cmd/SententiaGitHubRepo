extends CharacterBody3D

@onready var path_follow: PathFollow3D = get_parent()
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

var current_animation := ""
var flip_h := false
var last_position := Vector3.ZERO

func _ready():
	last_position = global_transform.origin

func _physics_process(delta: float) -> void:
	# Compute actual movement direction
	var movement = global_transform.origin - last_position
	last_position = global_transform.origin
	
	var anim_to_play := " "
	var new_flip_h := false
	
	if movement.length() < 0.01:
		# almost stationary → keep previous animation
		anim_to_play = current_animation if current_animation != "" else "Npc-Walk_down"
		new_flip_h = flip_h
	else:
		if abs(movement.x) > abs(movement.z):
			# horizontal dominant
			anim_to_play = "Npc-walk"
			new_flip_h = movement.x < 0
		else:
			# vertical dominant
			if movement.z > 0:
				anim_to_play = "Npc-walk_up"
				new_flip_h = false
			else:
				anim_to_play = "Npc - walk_down"
				new_flip_h = false

	# Apply animation only if changed
	if current_animation != anim_to_play or flip_h != new_flip_h:
		current_animation = anim_to_play
		flip_h = new_flip_h
		animated_sprite.animation = current_animation
		animated_sprite.flip_h = flip_h
		animated_sprite.play()
