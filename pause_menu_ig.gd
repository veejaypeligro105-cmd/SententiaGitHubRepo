extends Control


@onready var resumebtn = $VBoxContainer/Resume
@onready var mainmenubtn = $VBoxContainer/MainMenu
@onready var quitbtn = $VBoxContainer/Quit

func _ready() -> void:
	visible = false
	resumebtn.pressed.connect(_on_resume_pressed)
	mainmenubtn.pressed.connect(_on_main_menu_pressed)
	quitbtn.pressed.connect(_on_quit_pressed)

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	SceneManager.goto_scene("res://startup_menu.tscn", false)

func _on_quit_pressed() -> void:
	get_tree().quit()
