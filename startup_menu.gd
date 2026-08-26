extends Control


@onready var startbtn = $Title/CenterContainer/VBoxContainer/Start
@onready var loadbtn = $Title/CenterContainer/VBoxContainer/Load
@onready var settingsbtn = $Title/CenterContainer/VBoxContainer/Settings
@onready var quitbtn = $Title/CenterContainer/VBoxContainer/Quit
@onready var achivements = $Title/CenterContainer/VBoxContainer/Achivements
@onready var tutorialbtn = $Tutorial

func _ready() -> void:
	# Hide buttons first
	startbtn.visible = false
	loadbtn.visible = false
	settingsbtn.visible = false
	quitbtn.visible = false
	tutorialbtn.visible = false
	achivements.visible = false

	# Wait 1.5 seconds
	await get_tree().create_timer(1.5).timeout

	# Show buttons
	startbtn.visible = true
	loadbtn.visible = true
	settingsbtn.visible = true
	quitbtn.visible = true
	tutorialbtn.visible = true
	achivements.visible = true

	# Connect signals AFTER showing (optional but cleaner)
	startbtn.pressed.connect(_on_start_pressed)
	loadbtn.pressed.connect(_on_load_pressed)
	settingsbtn.pressed.connect(_on_settings_pressed)
	quitbtn.pressed.connect(_on_quit_pressed)
	tutorialbtn.pressed.connect(_on_tutorial_pressed)
	achivements.pressed.connect(_on_achivements_pressed)

func _process(delta: float) -> void:
	pass

# BUTTON FUNCTIONS
func _on_start_pressed() -> void:
	print("StartGame")
	SceneManager.goto_scene("res://difficulty_picker.tscn", false)

func _on_load_pressed() -> void:
	print("LoadGame")

func _on_settings_pressed() -> void:
	print("Settings")

func _on_tutorial_pressed() -> void:
	print("Tutorial")
	SceneManager.goto_scene("res://TutorialCombatScene/Tutorialmain_combat_scene.tscn", false)

func _on_achivements_pressed() -> void:
	print("Achievements")

func _on_quit_pressed() -> void:
	print("Quit")
	get_tree().quit()
