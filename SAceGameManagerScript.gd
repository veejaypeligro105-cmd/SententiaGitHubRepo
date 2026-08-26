extends Node

@onready var dialogue_ui = $"../InGame"
@onready var logic = $"../LogicEngine"

var Argument = preload("res://newcombatAce/Argument.gd")

const REWARD_SCENE_PATH := "res://RewardScene.tscn"

var player_hp := 100
var enemy_hp := 100

var current_argument: Argument
var current_values := {}

var current_case = 1

var current_correct_answer = ""
var current_choices = []
var case_id = 1

var battle_ended := false

func _ready() -> void:
	dialogue_ui.combat_manager = self
	
	HealthManager.reset_enemy()
	
	HealthManager.enemy_hp_changed.connect(_on_enemy_hp_changed)
	
	load_case(current_case)

func load_case(id: int) -> void:
	print(" LOADING CASE:", id)
	
	case_id=id
	
	current_argument = Argument.new()
	
	#await get_tree().process_frame  # IMPORTANT
	
	match id:

		1:
			current_argument.premises=["P -> Q","Q"]
			current_argument.conclusion="P"

			current_values={
				"P":false,
				"Q":true
			}

			current_correct_answer="Therefore Q"

			current_choices=[
				"Therefore P",
				"Therefore Q",
				"Therefore !Q"
			]

			dialogue_ui.show_question(
			"If P→Q, Q therefore P?"
			)

		2:
			current_argument.premises=["P -> Q","!P"]
			current_argument.conclusion="!Q"

			current_values={
				"P":false,
				"Q":true
			}

			current_correct_answer="No conclusion"

			current_choices=[
				"Therefore !Q",
				"No conclusion",
				"Therefore P"
			]

			dialogue_ui.show_question(
			"If P→Q, !P therefore !Q?"
			)

		3:

			current_argument.premises=["P -> Q","P"]
			current_argument.conclusion="Q"

			current_values={
				"P":true,
				"Q":true
			}

			current_correct_answer="Therefore Q"

			current_choices=[
				"Therefore P",
				"Therefore Q",
				"No conclusion"
			]

			dialogue_ui.show_question(
			"If P→Q, P therefore Q?"
			)

func load_next_case():	
	case_id +=1

	if case_id>3:
		case_id=1

	load_case(case_id)

func challenge_argument(arg: Argument, values: Dictionary) -> bool:
	if arg == null:
		print("ERROR: no argument")
		return false
 
	var result = arg.is_valid(logic, values)
 
	if result:
		print("VALID → argument holds")
	else:
		print("INVALID → OBJECTION!")

	return result

# VICTORY / REWARD FLOW
func _on_enemy_hp_changed(current: int, _max:int) -> void:
	if current <= 0 and not battle_ended:
		_end_battle_victory()
		
func _end_battle_victory() -> void:
	battle_ended = true
	
	var enemy_data: EnemyData = GameManager.current_enemy
	
	if enemy_data:
		GameManager.xp_before = PlayerStats.xp
		GameManager.xp_gained = enemy_data.xp_reward
		GameManager.add_gold(enemy_data.gold_reward)
		GameManager.dropped_items = enemy_data.item_drop.duplicate()
		GameManager.mark_enemy_defeated(enemy_data.enemy_id)
	else:
		print("Warning: GameManager.current_enemy was null - no rewards to give")
		
	SceneManager.goto_scene(REWARD_SCENE_PATH)
