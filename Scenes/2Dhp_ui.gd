extends Control

@onready var hp_bar = $HpBar
@onready var hp_text = $HpCount
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HealthManager.player_hp_changed.connect(update_hp)

	# INITIAL SYNC
	update_hp(HealthManager.player_hp, HealthManager.player_max_hp)
func update_hp(current, max_hp):
	hp_bar.max_value = max_hp
	hp_bar.value = current
	hp_text.text = "Sanity: " + str(current) + "/" + str(max_hp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
