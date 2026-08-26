extends Node

signal quest_started(quest_id: String)
signal quest_objective_updated(quest_id: String, objective: QuestObjective)
signal quest_completed(quest_id: String)

var quest_database: Dictionary = {}    # quest_id -> QuestData
var active_quests: Dictionary = {}     # quest_id -> QuestData (live progress)
var completed_quest_ids: Array = []


func _ready() -> void:
	_register_all_quests()
	start_quest("leave_home")   # first quest of the game — starts automatically


# =========================
# DEFINE YOUR QUESTS HERE
# (or skip this and build QuestData/.tres resources in the editor instead,
#  then call register_quest() with the loaded resource)
# =========================

func _register_all_quests() -> void:
	var clear_road := QuestData.new()
	clear_road.quest_id = "clear_road_gate"
	clear_road.title = "Clear the Road"
	clear_road.description = "Something is blocking the road out of town."

	var obj_barrier := QuestObjective.new()
	obj_barrier.type = QuestObjective.Type.REMOVE_BARRIER
	obj_barrier.target_id = "BarrierTest"       # must match Barrier1's barrier_id in the Inspector
	obj_barrier.required_amount = 1
	obj_barrier.description = "Clear the barrier blocking the road"

	clear_road.objectives = [obj_barrier]
	clear_road.reward_xp = 20
	clear_road.reward_gold = 10

	register_quest(clear_road)

	var leave_home := QuestData.new()
	leave_home.quest_id = "leave_home"
	leave_home.title = "Head Outside"
	leave_home.description = "Leave the house and step out onto the road."

	var obj_leave := QuestObjective.new()
	obj_leave.type = QuestObjective.Type.REACH_LOCATION
	obj_leave.target_id = "road_scene"          # matches the id Road.gd reports on arrival
	obj_leave.required_amount = 1
	obj_leave.description = "Go outside to the Road"

	leave_home.objectives = [obj_leave]

	register_quest(leave_home)

# =========================
#QUEST 2 
#TEST QUEST
# =========================

	var go_to_school := QuestData.new()
	go_to_school.quest_id = "go_to_school"
	go_to_school.title = "Something's Wrong here..."
	go_to_school.description = "Head to the school to find out what happened."
	
	var obj_school = QuestObjective.new()
	obj_school.type = QuestObjective.Type.REACH_LOCATION
	obj_school.target_id = "school_scene"
	obj_school.required_amount = 1
	obj_school.description = "Go to School"
	
	go_to_school.objectives = [obj_school]
	go_to_school.prerequisite_quest_ids = ["leave_home"] #Only becomes startable after quest 1 is finish
	
	register_quest(go_to_school)


func register_quest(quest: QuestData) -> void:
	quest_database[quest.quest_id] = quest


# =========================
# QUEST FLOW
# =========================
func can_start_quest(quest_id: String) -> bool:
	if not quest_database.has(quest_id):
		return false
	if is_quest_active(quest_id) or is_quest_completed(quest_id):
		return false

	var quest: QuestData = quest_database[quest_id]
	for prereq_id in quest.prerequisite_quest_ids:
		if not is_quest_completed(prereq_id):
			return false

	return true


func start_quest(quest_id: String) -> void:
	if not can_start_quest(quest_id):
		return

	var quest: QuestData = quest_database[quest_id]
	for objective in quest.objectives:
		objective.current_amount = 0

	active_quests[quest_id] = quest
	quest_started.emit(quest_id)


func is_quest_active(quest_id: String) -> bool:
	return active_quests.has(quest_id)


func is_quest_completed(quest_id: String) -> bool:
	return quest_id in completed_quest_ids


# =========================
# PROGRESS REPORTING
# Call this from Barrier.gd, EnemyNPC.gd, item pickups, dialogue — anything
# that finishes a task a quest might care about. It only affects quests that
# are currently active and actually have a matching objective, so it's safe
# to call this from anywhere, always, even with no quest running.
# =========================
func report_progress(type: QuestObjective.Type, target_id: String, amount: int = 1) -> void:
	for quest_id in active_quests.keys():
		var quest: QuestData = active_quests[quest_id]
		var quest_now_complete := true

		for objective in quest.objectives:
			if objective.type == type and objective.target_id == target_id and not objective.is_complete():
				objective.current_amount = min(objective.current_amount + amount, objective.required_amount)
				quest_objective_updated.emit(quest_id, objective)

			if not objective.is_complete():
				quest_now_complete = false

		if quest_now_complete:
			_complete_quest(quest_id)


func _complete_quest(quest_id: String) -> void:
	var quest: QuestData = active_quests[quest_id]

	active_quests.erase(quest_id)
	completed_quest_ids.append(quest_id)

	if quest.reward_xp > 0:
		GameManager.xp_gained += quest.reward_xp
	if quest.reward_gold > 0:
		GameManager.add_gold(quest.reward_gold)

	quest_completed.emit(quest_id)

	_try_auto_start_chained_quests()
	
# Checks every registered quest and auto-starts any whose prerequisites are
# now all satisfied. This is what makes "quest 2 begins once quest 1 finishes"
# happen without you needing to manually call start_quest() anywhere.
func _try_auto_start_chained_quests() -> void:
	for quest_id in quest_database.keys():
		if can_start_quest(quest_id):
			start_quest(quest_id)


# =========================
# HELPERS FOR UI
# =========================
func get_quest_data(quest_id: String) -> QuestData:
	return quest_database.get(quest_id, null)


func get_active_quest_ids() -> Array:
	return active_quests.keys()
