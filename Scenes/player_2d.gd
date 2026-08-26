extends CharacterBody2D

const SPEED = 150

@onready var animated_sprite = $AnimatedSprite2D
var current_animation := ""
var is_in_dialogue := false

func _physics_process(delta: float) -> void:
	# Stop movement during dialogue
	if is_in_dialogue:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Movement input
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_dir * SPEED
	
	move_and_slide()
	
	# Decide animation
	var anim_to_play := "Idle-2D"
	
	if input_dir != Vector2.ZERO:
		if abs(input_dir.x) > abs(input_dir.y):
			anim_to_play = "Walk-2D-Left-Right"
			animated_sprite.flip_h = input_dir.x < 0
		elif input_dir.y > 0:
			anim_to_play = "Walk-2D-Down"
		elif input_dir.y < 0:
			anim_to_play = "Walk-2D-Up"
	
	# Play animation
	if current_animation != anim_to_play:
		current_animation = anim_to_play
		animated_sprite.animation = current_animation
		animated_sprite.play()
