extends Control


@onready var video_player = $VideoStreamPlayer
@onready var skipbtn = $Button
@onready var pause_label = $PauseLabel

var skipped := false
var is_paused := false

func _ready():
	video_player.play()
	skipbtn.pressed.connect(_on_button_pressed)

	pause_label.visible = false

	await video_player.finished

	if not skipped:
		go_to_next_scene()

func _input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause()

func toggle_pause():
	if skipped:
		return
		
	is_paused = !is_paused

	video_player.paused = is_paused
	pause_label.visible = is_paused

	if is_paused:
		video_player.paused = true
	else:
		video_player.paused = false

func _on_button_pressed() -> void:
	if skipped:
		return

	skipped = true
	video_player.stop()
	go_to_next_scene()
	
func go_to_next_scene():
	SceneManager.goto_scene("res://Scenes/Intro_HomeLobby.tscn", true)
