extends Node2D

#Nodes
@onready var player_bar = $UI/Player/PlayerHPBAR
@onready var enemy_bar = $UI/Enemy/EnemyHPBAR
@onready var player_text = $UI/Player/PlayerHP
@onready var enemy_text = $UI/Enemy/EnemyHP
@onready var enemy_status = $UI/Enemy/Status
@onready var player_combo_label = $UI/Player/PComboLabel
@onready var player_damage_label =$UI/Player/PDamageLabel
@onready var enemy_combo_label =$UI/Enemy/EComboLabel1
@onready var enemy_damage_label = $UI/Enemy/EDamageLabel
@onready var inventory_button = $UI/Inventory
@onready var card_removerbtn = $UI/Skill
@onready var manager = $CardManager
#Animation
@onready var player_anim = $UI/Player/AnimatedSprite2D
@onready var enemy_anim = $UI/Enemy/AnimatedSprite2D

var current_question = null

var is_resolving := false

#Inventory
var inventoryscene = preload("res://2Dinventory_ui.tscn")
var inventory_instance = null
var inventory_open := false

#PopupScene
var ComboPopupScene = preload("res://cmbpopup.tscn")
var DamagePopupScene =preload("res://dmgpopup.tscn")

#new Damage system/ could change the base damage
var base_player_damage := 10
var base_enemy_damage := 10
#new Combo Tracker
var player_streak := 0 
var enemy_streak := 0

#Damage
var player_damage := 10
var enemy_damage := 10

var base_enemy_correct_chance := 0.5
var enemy_correct_chance := 0.5

var card_remover_cooldown := 5 #value of the cooldown
var card_remover_current_cd :=0

func _input(event):
	pass

func _ready():
	
#Get enemy from NPC
	var enemy = GameManager.current_enemy

	if enemy != null:
		setup_enemy(enemy)
		
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
# Difficulty settings
	var multiplier = GameManager.get_enemy_multiplier()

# scale damage
	base_enemy_damage = int(base_enemy_damage * multiplier)

# scale enemy accuracy
	enemy_correct_chance = base_enemy_correct_chance * multiplier
	enemy_correct_chance = clamp(enemy_correct_chance, 0.1, 0.95)

	update_enemy_status()

	inventory_button.pressed.connect(toggle_inventory)
	card_removerbtn.pressed.connect(_on_skill_pressed)

	HealthManager.player_hp_changed.connect(_on_player_hp_changed)
	HealthManager.enemy_hp_changed.connect(_on_enemy_hp_changed)

	$cardSlot.connect("card_played", _on_card_played)

	player_anim.play("Battle-Idle")
	enemy_anim.play("Battle-Npc-Idle")

	update_hp_ui()
	update_enemy_status()
	start_question()
	update_combat_ui()

func use_card_remover():
	if is_resolving:
		print("Can't use skill during the cooldown")
		return
	
	if card_remover_current_cd > 0:
		print("Skill on cooldown:", card_remover_current_cd)
		return

	var removed = manager.remove_one_wrong_card()
	
	if removed:
		show_dialogue("Removed a wrong card! ")
		await get_tree().create_timer(1.0).timeout #wait briefy then restore the question
		restore_question_text()
		
		card_remover_current_cd = card_remover_cooldown
	else:
		show_dialogue("No wrong card to remove!")
		
	update_skill_ui()

func restore_question_text():
	if current_question != null:
		show_dialogue("[" + current_question["type"] + "]\n" + current_question["question"])


func _on_player_hp_changed(current, max_hp):
	player_bar.max_value = max_hp
	player_bar.value = current
	player_text.text = "HP: %d" % current

func _on_enemy_hp_changed(current, max_hp):
	enemy_bar.max_value = max_hp
	enemy_bar.value = current
	enemy_text.text = "HP: %d" % current

	#handling close and inside inventory
func _on_inventory_closed():
	if inventory_instance:
		inventory_instance.hide()
	
	get_tree().paused = false
	inventory_open = false

# HP UI
func update_hp_ui():
	player_bar.max_value = HealthManager.player_max_hp
	enemy_bar.max_value = HealthManager.enemy_max_hp

	player_bar.value = HealthManager.player_hp
	enemy_bar.value = HealthManager.enemy_hp

	player_text.text = "HP: " + str(HealthManager.player_hp)
	enemy_text.text = "HP: " + str(HealthManager.enemy_hp)
func update_combat_ui():
	#Player UI
	player_combo_label.text = "Combo: x" + str(player_streak)
	player_damage_label.text = "DMG: x" + str(player_damage)
	#Enemy UI
	enemy_combo_label.text = "Combo: x" + str(enemy_streak)
	enemy_damage_label.text = "DMG: x" + str(enemy_damage)

#toggle inventory
func toggle_inventory():
	if inventory_open:
		if inventory_instance:
			inventory_instance.hide()
		get_tree().paused = false
		inventory_open = false
	else:
		if inventory_instance == null:
			inventory_instance = inventoryscene.instantiate()
			add_child(inventory_instance)
			#connect close signal
			inventory_instance.inventory_closed.connect(_on_inventory_closed)
		
		inventory_instance.show()
		get_tree().paused = true
		inventory_open = true
# START QUESTION
func start_question():
	if is_resolving:
		return

	current_question = Database.get_random_question()

	if current_question == null:
		show_dialogue("No questions found!")
		return

	show_dialogue("[" + current_question["type"] + "]\n" + current_question["question"])

	
	manager.reset_cards()
	manager.spawn_question_cards(current_question)

# CARD PLAYED
func _on_card_played(card):
	if is_resolving:
		return
	resolve_battle(card)

# BATTLE LOGIC
func resolve_battle(card):
	is_resolving = true

	# Stop any stuck animation
	player_anim.stop()

#Player Answer Correct line of code
	if card.is_correct:
		show_dialogue("Correct! You dealt damage!")

#combo increase damage
		player_streak += 1
		player_damage  = base_player_damage + (player_streak - 1)

		spawn_combo_popup($UI/Player/AnimatedSprite2D, player_streak)

		player_anim.play("Battle-Attack")
		await player_anim.animation_finished

		enemy_anim.play("Battle-Npc-Hurt")
		await enemy_anim.animation_finished
		
		spawn_damage_popup(enemy_anim, player_damage)
		deal_damage_to_enemy(player_damage) #deal damage to enemy
		Database.mark_question_used(current_question["id"])
#Player answered wrong
	else:
		show_dialogue("Wrong answer...")
		await get_tree().create_timer(1.0).timeout

		player_streak = 0
		player_damage = base_player_damage

		spawn_combo_popup($UI/Player/AnimatedSprite2D, 0)
		update_combat_ui()

		show_dialogue("Enemy is thinking...")
		await get_tree().create_timer(1.5).timeout
#Enemy got the answer right
		if randf() < enemy_correct_chance:
			show_dialogue("Enemy got it right!")
			#Enemy combo increase
			enemy_streak += 1
			enemy_damage = base_enemy_damage + (enemy_streak - 1)

			spawn_combo_popup($UI/Enemy/AnimatedSprite2D, enemy_streak)
			update_combat_ui()

			enemy_anim.play("Battle-Npc-Attack")
			await enemy_anim.animation_finished

			player_anim.play("Battle-Hurt")
			await player_anim.animation_finished

			spawn_damage_popup(player_anim, enemy_damage)
			deal_damage_to_player(enemy_damage)#Deal Damage to Player
			Database.mark_question_used(current_question["id"])

			enemy_correct_chance = base_enemy_correct_chance
			update_enemy_status()
			
#Enemy Failed the correct answer
		else:
			show_dialogue("Enemy failed!")
			
			#enemy combo reset
			enemy_streak = 0
			enemy_damage = base_enemy_damage

			spawn_combo_popup($UI/Enemy/AnimatedSprite2D, 0)
			update_combat_ui()

			enemy_correct_chance += 0.05
			enemy_correct_chance = clamp(enemy_correct_chance, 0.1, 0.95)
			update_enemy_status()

	$CardManager.remove_card_from_slot(card)

	player_anim.stop()
	enemy_anim.stop()
	
	enemy_anim.play("Battle-Npc-Idle")
	player_anim.play("Battle-Idle")

	await get_tree().create_timer(0.5).timeout

	is_resolving = false
	
	if card_remover_current_cd > 0:
		card_remover_current_cd -= 1

	update_skill_ui()

	start_question()

func update_skill_ui():
	if card_remover_current_cd > 0:
		card_removerbtn.text = "Card Remover (" + str(card_remover_current_cd) + ")"
		card_removerbtn.disabled = true
	else:
		card_removerbtn.text = "Card Remover"
		card_removerbtn.disabled = false

# DAMAGE
func deal_damage_to_enemy(amount):
	HealthManager.damage_enemy(amount)
	check_battle_end()

func deal_damage_to_player(amount):
	HealthManager.damage_player(amount)
	check_battle_end()

func check_battle_end():
	print("CHECK BATTLE END CALLED")

	if HealthManager.enemy_hp <= 0:
		get_tree().paused = true
		give_rewards()
		GameManager.enemy_was_defeated = true
		end_battle()

	elif HealthManager.player_hp <= 0:
		get_tree().paused = true
		GameManager.enemy_was_defeated = false
		end_battle()
		
#Giving rewards/drops
func give_rewards():
	GameManager.mark_enemy_defeated(GameManager.current_enemy.enemy_id)
	
	var enemy = GameManager.current_enemy
	
	if enemy == null:
		print("No enemy found")
		return

	# XP
	GameManager.xp_gained = enemy.xp_reward
	
	GameManager.xp_before = PlayerStats.xp

	GameManager.mark_enemy_defeated(enemy.enemy_id)
	# GOLD
	GameManager.add_gold(enemy.gold_reward)

	# ITEMS
	GameManager.dropped_items.clear()

	if enemy.item_drop != null:
		for item in enemy.item_drop:
			if item != null and randf() < 0.5:
				GameManager.dropped_items.append(item)
				Inventory.add_item(item)

#ENEMY CHANCE UI
func update_enemy_status():
	var percent = int(enemy_correct_chance * 100)
	var state = ""

	if percent <= 50:
		state = "Unstable"
		enemy_status.modulate = Color.WHITE
		
	elif percent < 75:
		state = "Focusing"
		enemy_status.modulate = Color.ORANGE
	else:
		state = "Locked In"
		enemy_status.modulate = Color.RED
		
	enemy_status.text = state + " (" + str(percent) + "%)"

#Combo spawn
func spawn_combo_popup(target_node: Node, value: int):
	#popup dont popup  if no combo
	if value <= 0:
		return
		
	var popup = ComboPopupScene.instantiate()
	
	popup.text = "+" + str(value) + " Combo"
	
	#Spawn near Character
	target_node.add_child(popup)
	#position above the character
	popup.position = Vector2(0, -40)

#Dmgpopup
func spawn_damage_popup(target_node: Node, amount: int):
	var dmgpopup = DamagePopupScene.instantiate()
	
	dmgpopup.text = "-" + str(amount)
	
	target_node.add_child(dmgpopup)
	dmgpopup.position = Vector2(0, -40)


func setup_enemy(enemy: EnemyData):
	if enemy == null:
		return

	base_enemy_damage = enemy.base_damage
	HealthManager.enemy_max_hp = enemy.max_hp
	HealthManager.enemy_hp = enemy.max_hp

	if enemy.sprite_2d_frames:
		enemy_anim.sprite_frames = enemy.sprite_2d_frames

		var prefix = enemy.anim_prefix

		if enemy_anim.sprite_frames.has_animation(prefix + "-Idle"):
			enemy_anim.play(prefix + "-Idle")

	enemy_anim.flip_h = true
# UI
func show_dialogue(text):
	$UI/DialogueBox/Text.text = text

#defeat Player/Enemy
func end_battle():
	print("END BATTLE CALLED")

	is_resolving = true
	get_tree().paused = false

	await get_tree().process_frame

	get_tree().change_scene_to_file("res://RewardScene.tscn")

func _load_return_scene(scene_path):
	print("LOADING SCENE:", scene_path)
	get_tree().change_scene_to_file(scene_path)

# SCENE CHANGE
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://new-newNewSchool/NewSchool.tscn")


func _on_inventory_pressed() -> void:
	pass # Replace with function body.


func _on_skill_pressed() -> void:
	use_card_remover()
