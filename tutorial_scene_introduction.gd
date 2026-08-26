extends Control


var pages = []
var current_page = 0


@onready var next_scene: String = "res://startup_menu.tscn" #change this if the tutorial was implemented on the school
@onready var previous_scene: String = "res://startup_menu.tscn"


@onready var text_label = $MarginContainer/VBoxContainer/RichTextLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	pages = [
		"Welcome to SENTENTIA

In this world, logic is power.

You will face enemies using your knowledge of logic.
Every correct answer lets you attack.
Every mistake gives your enemy an advantage.

Learn carefully. Think critically. Win battles.",


"CARD SYSTEM
Each card represents a logic operation:

Knight → AND (∧)
Archer → NOT (¬)
Demon → OR (∨)

You must choose the correct card based on the question.

Example:
If the question asks for BOTH conditions to be true → use AND.
If it asks to reverse a value → use NOT.
If it accepts at least one true → use OR.

Choosing the wrong card will result in failure.",


"BATTLE SYSTEM

Battles are turn-based.

If your answer is CORRECT:
→ You deal damage to the enemy.

If your answer is WRONG:
→ The enemy attacks you.

There is no guessing — every decision matters.
Think before you act.",


"ENEMY INTELLIGENCE

Each enemy has an intelligence level.

It starts at 50%.

Every time you answer incorrectly:
→ Enemy intelligence increases by 5%.

Higher intelligence means:
→ Enemies become harder to defeat.

Answer correctly to reset it back to 50%.

Mistakes make your enemy stronger.",


"PROPOSITIONAL LOGIC

You will use basic logic operations:

NOT (¬p)
→ Reverses the truth value
→ If p is TRUE, ¬p is FALSE

AND (p ∧ q)
→ TRUE only if BOTH are TRUE

OR (p ∨ q)
→ TRUE if at least one is TRUE

Understanding these is the key to winning.",


"TRUTH TABLES
Truth tables help you evaluate logic expressions.

Number of rows depends on variables:

2 variables → 4 rows
3 variables → 8 rows

Example (AND):
p  q  |  p ∧ q
T  T  |   T
T  F  |   F
F  T  |   F
F  F  |   F
Use truth tables to guide your answers.",


"WINNING THE GAME

To win:

→ Reduce the enemy's HP to 0.

You do this by:
✔ Answering correctly
✔ Choosing the correct logic card
✔ Understanding the system

This is not just a game —
it is a test of your logic skills.

Good luck."
]
	update_page()
	
	
func update_page():
	text_label.text = pages [current_page]


func _on_next_pressed() -> void:
	if current_page < pages.size() - 1:
		current_page += 1
		update_page()
	else:
		get_tree().change_scene_to_file(next_scene)

func _on_back_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		update_page()
	else:
		get_tree().change_scene_to_file(previous_scene)

func _process(delta: float) -> void:
	pass
