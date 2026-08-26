extends Control

@onready var quest_text = $Questlogpanel/VBoxContainer/QuestText

var current_quest := ""

func _ready() -> void:
	print("QUEST UI LOADED")
	update_quest_log("No active quest yet.")

func update_quest_log(text: String) -> void:
	var safe_text := text

	if safe_text.length() > 160:
		safe_text = safe_text.substr(0, 160) + "..."

	quest_text.text = "QUEST LOG:\n\n" + safe_text

	# Force label to resize properly
	quest_text.size = quest_text.get_combined_minimum_size()
