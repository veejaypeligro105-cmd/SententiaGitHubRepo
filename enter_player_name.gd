extends Node2D

@onready var name_input = $UI/Control/NameInput
@onready var continuebtn = $UI/Control/Continue

var player_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect button
	continuebtn.pressed.connect(_on_button_pressed)
	
	# Connect Enter key from LineEdit
	name_input.text_submitted.connect(_on_name_input_text_submitted)


func _on_button_pressed() -> void:
	submit_name()
	get_tree().change_scene_to_file("res://Scenes/Intro_HomeLobby.tscn")
	
func _on_name_input_text_submitted(new_text: String) -> void:
	submit_name()

func submit_name():
	player_name = name_input.text.strip_edges()
	
	if player_name == " ":
		name_input.placeholder_text = "Please enter a name!"
		return
		
	print("Player Name: ", player_name)


func _process(delta: float) -> void:
	pass
