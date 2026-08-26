extends Node2D
class_name  EntryPoint

#Place one at every entry spot in a scene the player might arrived at.
#Give it an Entry_id that matchesa LinkScene's entry_point_id

@export var entry_id: String = ""

func _ready() -> void:
	add_to_group("entry_point")
