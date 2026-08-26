extends Area2D
class_name Exit_Scene

@export var target_scene_id: String = "" #must be match a SceneLink's id in SceneRegistry
@export var transition_delay: float = 0.05 #Small delay, to avoid re triggering issues

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and not triggered and Input.is_action_just_pressed("Interact"):
		_trigger_exit()
		
		
func _trigger_exit() -> void:
	if triggered:
		return
	if target_scene_id == "":
		print("ExitScene: no target_scene_id set")
		return

	triggered = true
	
	GameManager.return_scene = get_tree().current_scene.scene_file_path
	if player_ref:
		GameManager.player_return_position = player_ref.global_position
		
	QuestManager.report_progress(QuestObjective.Type.REACH_LOCATION, "road_scene")
	
	await get_tree().create_timer(transition_delay).timeout
	
	SceneManager.goto_scene_by_id(target_scene_id, true)
