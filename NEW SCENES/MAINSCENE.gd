extends Node

#Make an NPC for floor 1 to 2 with the questions corresponding questions
#in UI Separate the Quest Tracker from the UI, Also hide the UI in the Menu.
#Clean up Combat System UI Change the position of the buttons below.
#Use Shaders, and add some music in the main.
#Make Scene Transition (fading in and out. or something if nag provide )
#In the combat system asset placement and combat system in general.
#if the player got the correct answer it will pan the camera or stack the scene make
#the button dialogue panel, Hud disappear as the player explain why that was the correct answer
#if the player got the wrong answer the enemy will explain instead.

@export_file("*.tscn") var starting_scene : String = ""

@onready var scene_container : Node = $SceneContainer
@onready var hud: CanvasLayer = $HUD
@onready var global_ui: CanvasLayer = $GlobalUI

@onready var pause_menu: CanvasLayer = $"GlobalUI/2DpausemenuIG"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fix_ui_layering()

	SceneManager.register_container(scene_container)
	SceneManager.register_hud(hud)
	SceneManager.register_global_ui(global_ui)
	
	SceneManager.goto_scene(starting_scene, false)

func _fix_ui_layering() -> void:
	global_ui.layer = 50
	hud.layer = 40
