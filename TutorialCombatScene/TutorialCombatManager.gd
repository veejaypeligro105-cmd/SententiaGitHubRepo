extends Node

@onready var dialogue_ui = $"../InGame"
@onready var logic = $"../LogicEngine"
var Argument = preload("res://newcombatAce/Argument.gd")

var current_argument = Argument
var current_values := {}
var current_correct_answer := ""
var current_choices := []


func _ready() -> void:
	dialogue_ui.combat_manager = self
	dialogue_ui.timer_enabled = false
	HealthManager.reset_enemy()
	_load_tutorial_case()
	
func _load_tutorial_case() -> void:
	current_argument = Argument.new()
	current_argument.premises = ["P -> Q", "Q"]
	current_argument.conclusion = "P"
	current_values = {"P": false, "Q": true}
	current_correct_answer = "Therefore Q"
	current_choices = [
		"Therefore P",
		"Therefore Q",
		"Therefore !Q"
	]
	dialogue_ui.show_question("If P→Q, Q therefore P?")

func challenge_argument(arg: Argument, values: Dictionary) -> bool:
	if arg == null:
		return false
	return arg.is_valid(logic, values)

func load_next_case() -> void:
	_load_tutorial_case()
