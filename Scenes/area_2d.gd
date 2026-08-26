extends Area2D
class_name ExitScene

@export_file("*.tscn") var target_scene: String = "res://Isometric/tscn/road.tscn"  # scene to load
@export var transition_delay: float = 0.05  # small delay, avoids re-triggering issues
 
var player_in_range := false
var triggered := false
var player_ref: Node2D = null
 
 
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
 
 
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_ref = body
 
 
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		player_ref = null
 
 
func _process(_delta: float) -> void:
	if player_in_range and not triggered and Input.is_action_just_pressed("Interact"):
		_trigger_exit()
 
 
func _trigger_exit() -> void:
	if triggered:
		return
	if target_scene == "":
		print("SceneExit: No target_scene set")
		return
 
	triggered = true
 
	# Remember where we're leaving from, same pattern as EnemyNPC.gd uses
	GameManager.return_scene = get_tree().current_scene.scene_file_path
	if player_ref:
		GameManager.player_return_position = player_ref.global_position
 
	# Report quest progress at the moment of leaving, not arriving
	QuestManager.report_progress(QuestObjective.Type.REACH_LOCATION, "road_scene")
 
	await get_tree().create_timer(transition_delay).timeout
 
	SceneManager.goto_scene(target_scene, true)
