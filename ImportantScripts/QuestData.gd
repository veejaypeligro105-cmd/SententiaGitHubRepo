extends Resource
class_name QuestData

@export var quest_id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""

@export var objectives: Array[QuestObjective] = []
@export var prerequisite_quest_ids: Array[String] = [] #Quest that must be completed First

@export var reward_xp: int = 0
@export var reward_gold: int = 0
@export var reward_item_ids: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
