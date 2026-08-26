extends StaticBody2D
class_name Barrier

@export var barrier_id: String = ""          # unique id, used to remember it's gone (for GameManager persistence)
@export var disappear_sound: AudioStream      # optional
@export var fade_time: float = 0.3

signal barrier_removed(barrier_id: String)    # hook this up to your future Quest Manager

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $Interaction_Area   # FIXED: matches your tree's "Interaction_Area" (with underscore)
@onready var audio_player: AudioStreamPlayer2D = get_node_or_null("AudioStreamPlayer2D")

var player_in_range := false
var is_removed := false


func _ready() -> void:
	add_to_group("barrier")

	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)

	# If GameManager already remembers this barrier as removed (e.g. loaded a save
	# or came back from another scene), skip straight to gone. Remove this block
	# if you don't have a GameManager.removed_barrier_ids array yet.
	
	if barrier_id != "" and "removed_barrier_ids" in GameManager and barrier_id in GameManager.removed_barrier_ids:
		_remove_immediately()


func _process(_delta: float) -> void:
	if player_in_range and not is_removed and Input.is_action_just_pressed("Interact"):
		interact()


func _on_interaction_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_interaction_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false


# =========================
# INTERACT (call this from Quest Manager too, e.g. after a condition is met)
# =========================

func interact() -> void:
	if is_removed:
		return

	is_removed = true

	if barrier_id != "" and "removed_barrier_ids" in GameManager:
		GameManager.removed_barrier_ids.append(barrier_id)

	if audio_player and disappear_sound:
		audio_player.stream = disappear_sound
		audio_player.play()

	barrier_removed.emit(barrier_id)

	_disappear()


func _disappear() -> void:
	# Turn off collision immediately so the player can walk through
	# as soon as the fade starts, not only after it finishes.
	collision_shape.set_deferred("disabled", true)

	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, fade_time)
		tween.tween_callback(queue_free)
	else:
		queue_free()


func _remove_immediately() -> void:
	is_removed = true
	collision_shape.set_deferred("disabled", true)
	queue_free()
