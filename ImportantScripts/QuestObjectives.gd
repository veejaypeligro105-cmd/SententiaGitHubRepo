extends Resource
class_name QuestObjective

enum Type{
	DEFEAT_ENEMY,
	REMOVE_BARRIER,
	COLLECT_ITEM,
	TALK_TO_NPC,
	REACH_LOCATION
}

@export var type: Type = Type.DEFEAT_ENEMY
@export var target_id: String = ""  #must match the Id used by the the thing being Tracked
									#example an EnemyData.Enemy_id or a Barrier's Barrier ID

@export var required_amount: int = 1
@export var description: String = "" #Shown in UI, example "Clear the Road Barrier or Kill enemies

var current_amount: int = 0

func is_complete() -> bool:
	return current_amount >= required_amount

func get_progress_text() -> String:
	if description != "":
		return "%s (%d/%d)" % [description, current_amount, required_amount]
	return "%d/%d" % [current_amount, required_amount]
