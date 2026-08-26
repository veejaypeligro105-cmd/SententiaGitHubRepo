extends Node

var scenes: Dictionary = {}               #scene_id -> SceneData

func _ready() -> void:
	_register_all_scenes()

#============================================================
#REGISTER EVERY SCENES HERE - ONE LINE EACH
#ADD NEW LEVELS AS BUILDING THEM SO THAT I CAN REGISTER THE ID
#============================================================

func _register_all_scenes() -> void:
	_add_scene("intro_scene", "res://Scenes/Intro_HomeLobby.tscn")
	_add_scene("home_lobby" ,"res://Scenes/home_lobby_gp.tscn" )
	_add_scene("Road", "res://Isometric/tscn/road.tscn")
	
	_add_scene("tutorial_battle", "res://TutorialCombatScene/Tutorialmain_combat_scene.tscn")
	#_add_scene("start_up_menu", "res://startup_menu.tscn")
	#_add_scene("Main_Combat", "res://SAmain_combat_scene.tscn")

func _add_scene(id: String, path: String) -> void:
	var data := SceneData.new()
	data.scene_id = id
	data.scene_path = path
	scenes[id] = data

func get_scene_path(scene_id: String) -> String:
	if not scenes.has(scene_id):
		push_error("SceneRegistry: no scene registered with id '%s'" % scene_id)
		return ""
	return scenes[scene_id].scene_path
