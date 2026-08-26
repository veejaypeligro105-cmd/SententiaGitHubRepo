extends CanvasLayer

@onready var dresumebtn = $"2Dpausemenu_IG/VBoxContainer/Resume"
@onready var dmainmenubtn = $"2Dpausemenu_IG/VBoxContainer/Mainmenu"
@onready var dquitbtn = $"2Dpausemenu_IG/VBoxContainer/Quit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("pause_menu")
	
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	dresumebtn.pressed.connect(_on_resume_pressed)
	dmainmenubtn.pressed.connect(_on_mainmenu_pressed)
	dquitbtn.pressed.connect(_on_quit_pressed)

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_mainmenu_pressed() -> void:
	get_tree().paused = false
	SceneManager.goto_scene("res://startup_menu.tscn", false)

func _on_quit_pressed() -> void:
	get_tree().quit()
