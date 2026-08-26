extends Node

var level := 1
var xp := 0
var xp_to_next := 50

signal xp_changed

func add_xp(amount: int):
	xp += amount
	print("Gained XP:", amount)
	
	while xp >= xp_to_next:
		xp -= xp_to_next
		level_up()

func level_up():
	level += 1
	xp_to_next = int(xp_to_next * 1.5)
	
	print("LEVEL UP! Now Level:", level)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
