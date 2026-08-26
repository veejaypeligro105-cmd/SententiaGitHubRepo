extends Control

@onready var easybtn =$Easy
@onready var normalbtn =$Normal
@onready var hardbtn = $Hard
@onready var continuebtn = $Continue
@onready var title = $Title


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = "Select Difficulty"

	easybtn.pressed.connect(func(): select_difficulty(GameManager.Difficulty.EASY))
	normalbtn.pressed.connect(func(): select_difficulty(GameManager.Difficulty.NORMAL))
	hardbtn.pressed.connect(func(): select_difficulty(GameManager.Difficulty.HARD))

	continuebtn.pressed.connect(go_to_cutscene)

#Set difficulty
func select_difficulty(diff):
	GameManager.selected_difficulty = diff

	print("Difficulty selected:", diff)

	#Next Scene
func go_to_cutscene():
	SceneManager.goto_scene("res://CutScenes/cutscene.tscn", true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_easy_pressed() -> void:
	pass # Replace with function body.


func _on_normal_pressed() -> void:
	pass # Replace with function body.


func _on_hard_pressed() -> void:
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	pass # Replace with function body.
