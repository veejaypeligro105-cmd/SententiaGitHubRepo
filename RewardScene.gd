extends Control

@onready var xp_label =$CanvasLayer/Panel/Xplabel
@onready var gold_label =$CanvasLayer/Panel/Goldlabel
@onready var loot_container=$CanvasLayer/Panel/LootContainer
@onready var nextbtn = $CanvasLayer/Panel/Nextbutton
@onready var xpbar = $CanvasLayer/Panel/xpbar

var animating := false

func _ready() -> void:
	xp_label.text = "XP Gained: " + str(GameManager.xp_gained)
	gold_label.text = "Gold: " + str(GameManager.gold)

	for item in GameManager.dropped_items:
		var label = Label.new()
		label.text = item.item_name
		loot_container.add_child(label)

	nextbtn.pressed.connect(_on_nextbutton_pressed)

	# Initialize bar BEFORE animation
	xpbar.max_value = PlayerStats.xp_to_next
	xpbar.value = GameManager.xp_before

	start_xp_animation()

func start_xp_animation():
	if animating:
		return

	animating = true

	var start_xp = GameManager.xp_before
	var gained = GameManager.xp_gained

	var target_xp = start_xp + gained

	while PlayerStats.xp < target_xp:
		await get_tree().create_timer(0.02).timeout

		PlayerStats.add_xp(1)

		xpbar.max_value = PlayerStats.xp_to_next
		xpbar.value = PlayerStats.xp

	animating = false

func _on_nextbutton_pressed() -> void:
	PlayerStats.add_xp(GameManager.xp_gained)
	GameManager.reset_battle_rewards()
	get_tree().change_scene_to_file(GameManager.return_scene)
