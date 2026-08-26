extends Control

#MOVE THE QUEST TRACKER

@onready var quest_title_label: Label = $VBoxContainer/QuestTitle
@onready var objectives_container: VBoxContainer = $"VBoxContainer/Objectives List"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QuestManager.quest_started.connect(_on_quest_changed)
	QuestManager.quest_objective_updated.connect(_on_objective_updated)
	QuestManager.quest_completed.connect(_on_quest_changed)
	
	refresh_display()


func _on_quest_changed(_quest_id: String) -> void:
	refresh_display()


func _on_objective_updated(quest_id: String, QuestObjective) -> void:
	refresh_display()

func refresh_display() -> void:
	for child in objectives_container.get_children():
		child.queue_free()

	var active_ids := QuestManager.get_active_quest_ids()

	if active_ids.is_empty():
		visible = false
		return

	visible = true

# Shows the first active quest. If you want to track multiple quests
# at once later, loop over active_ids and build one block per quest.

	var quest_id: String = active_ids[0]
	var quest: QuestData = QuestManager.get_quest_data(quest_id)

	quest_title_label.text = quest.title
	
	for objective in quest.objectives:
		var label := Label.new()
		label.text = objective.get_progress_text()
		if objective.is_complete():
			label.modulate = Color(0.4, 1.0, 0.4)
		objectives_container.add_child(label)
