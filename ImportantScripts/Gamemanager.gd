extends Node

enum Difficulty {
	EASY,
	NORMAL,
	HARD
}

var selected_difficulty: Difficulty = Difficulty.NORMAL

# =========================
# COMBAT / RETURN STATE
# =========================
var current_enemy: EnemyData
var return_scene: String = ""
var player_scene: String = ""

var player_return_position: Vector2          
var return_position := Vector2.ZERO          
var return_rotation := 0.0                  

var return_npc_id := ""
var enemy_was_defeated := false

# =========================
# REWARDS
# =========================
var xp_gained := 0
var xp_before := 0
var dropped_items: Array = []
var gold := 0

signal gold_changed

# =========================
# PERSISTENCE
# =========================
var defeated_npc_ids := []
var removed_barrier_ids := []          # ADDED: for Barrier.gd persistence

# =========================
# GOLD
# =========================
func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit()

func spend_gold(amount: int) -> void:
	gold = max(gold - amount, 0)
	gold_changed.emit()

# =========================
# DIFFICULTY
# =========================
func get_enemy_multiplier() -> float:
	match selected_difficulty:
		Difficulty.EASY:
			return 0.7
		Difficulty.NORMAL:
			return 1.0
		Difficulty.HARD:
			return 1.5
	return 1.0

# =========================
# BATTLE REWARDS
# =========================
func reset_battle_rewards() -> void:
	xp_gained = 0
	dropped_items.clear()

# =========================
# PERSISTENCE HELPERS
# =========================
func mark_enemy_defeated(enemy_id: String) -> void:
	if enemy_id not in defeated_npc_ids:
		defeated_npc_ids.append(enemy_id)

func mark_barrier_removed(barrier_id: String) -> void:      # ADDED
	if barrier_id not in removed_barrier_ids:
		removed_barrier_ids.append(barrier_id)

# =========================
# LIFECYCLE
# =========================
func _ready() -> void:
	pass # Replace with function body.
