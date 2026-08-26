extends Node

var current_scene: Node = null
var scene_container: Node = null
var hud: CanvasLayer = null
var global_ui: CanvasLayer = null

const EXPLORATION_SCENE_IDS := ["intro_scene", "home_lobby","start_up_menu","Road","Main_Combat"]

# Called once by Main.gd on startup — tells SceneManager where "levels" go.
func register_container(container: Node) -> void:
	scene_container = container
	if scene_container.get_child_count() > 0:
		current_scene = scene_container.get_child(0)

func register_hud(hud_layer: CanvasLayer) -> void:
	hud = hud_layer
	hud.visible = false

func register_global_ui(ui: CanvasLayer) -> void:
	global_ui = ui
	global_ui.visible = false

@warning_ignore("unused_parameter")
func goto_scene_id(scene_id: String, show_ui: bool = true) -> void:
	var path := SceneRegistry.get_scene_path(scene_id)
	if path == "":
		return
	call_deferred("_deferred_goto_scene", path, scene_id in EXPLORATION_SCENE_IDS)

# Raw-path fallback (e.g. GameManager.return_scene). No id available here,
# so it falls back to matching by path against the registry.
@warning_ignore("unused_parameter")

func goto_scene(path: String, show_ui: bool = true) -> void:
	var is_exploration := false
	for id in EXPLORATION_SCENE_IDS:
		var registered_path = SceneRegistry.get_scene_path(id)
		print("checking id '", id, "' -> '", registered_path, "'")
		if registered_path == path:
			is_exploration = true
			print("  MATCHED against incoming path: ", path)
			break
	call_deferred("_deferred_goto_scene", path, is_exploration)

func _deferred_goto_scene(path: String, show_ui: bool) -> void:
	if current_scene:
		current_scene.queue_free()
	if hud:
		hud.visible = show_ui
		print("SceneManager: loaded '", path, "' — hud.visible set to ", hud.visible)
	
	var next_scene_resource: PackedScene = load(path)
	current_scene = next_scene_resource.instantiate()
	scene_container.add_child(current_scene)

	if hud:
		hud.visible = show_ui

func _move_player_to_entry_point(entry_id: String) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	for entry_point in get_tree().get_nodes_in_group("entry_point"):
		if entry_point.entry.id == entry_id:
			player.global.position = entry_point.global_position
			return

	print("SceneManager: No entryPoint found with id ", entry_id, "")
