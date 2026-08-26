extends Node

signal player_hp_changed(current, max)
signal enemy_hp_changed(current, max)

#player
var player_max_hp := 100
var player_hp := 100

#enemy(for combat)
var enemy_max_hp := 100
var enemy_hp := 100

#Player function
func damage_player(amount: int):
	player_hp = max(player_hp - amount, 0)
	player_hp_changed.emit(player_hp, player_max_hp)

func heal_player(amount: int):
	player_hp = min(player_hp + amount, player_max_hp)
	player_hp_changed.emit(player_hp, player_max_hp)

#Enemy
func damage_enemy(amount: int):
	enemy_hp = max(enemy_hp - amount, 0)
	enemy_hp_changed.emit(enemy_hp, enemy_max_hp)

func reset_enemy():
	enemy_hp = enemy_max_hp
	enemy_hp_changed.emit(enemy_hp, enemy_max_hp)

func _ready() -> void:
	player_hp_changed.emit(
		player_hp,
		player_max_hp
	)
	enemy_hp_changed.emit(
		enemy_hp,
		enemy_max_hp
	)
