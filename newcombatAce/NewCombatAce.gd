extends Control

@onready var feedback_label = $FeedBackLabel
@onready var player_hp_bar = $PlayerHpBar
@onready var enemy_hp_bar = $EnemyHpBar
@onready var confirm_panel = $ConfirmationPanel
@onready var confirm_label = $ConfirmationPanel/ConfirmationLabel
@onready var btn_challenge =$ButtonContainer/BtnChallenge
@onready var btn_present =$ButtonContainer/BtnPresent
@onready var btn_inventory = $ButtonContainer/BtnInventory
@onready var timer_label = get_node_or_null("Timer")


@onready var present_panel = $PresentPanel
@onready var present_label = $PresentPanel/PresentLabel

@onready var choice1 = $PresentPanel/Btnchoice1
@onready var choice2 = $PresentPanel/Btnchoice2
@onready var choice3 = $PresentPanel/Btnchoice3

#@onready var inventory_ui = "res://2Dinventory_ui.tscn"

var health = HealthManager

var statement_label: RichTextLabel 

var current_index := 0
var statements: Array = []

var time_left := 10.0
var timer_active := false

var combat_manager
var current_statement
var current_values = {}

var current_argument: Argument

var ui_ready := false
var must_present = false

var timer_left := 10.0
var timer_running := false

var timer_enabled := true

var player_bar_base_color := Color.WHITE
var enemy_bar_base_color := Color.WHITE

func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	await get_tree().process_frame

	player_bar_base_color = player_hp_bar.modulate
	enemy_bar_base_color = enemy_hp_bar.modulate
	
	print("PLAYER BAR NODE:", get_node_or_null("PlayerHpBar"))
	print("ENEMY BAR NODE:", get_node_or_null("EnemyHpBar"))

	HealthManager.player_hp_changed.connect(
		update_player_hp
	)
	
	HealthManager.enemy_hp_changed.connect(
		update_enemy_hp
	)
	
	update_player_hp(
		HealthManager.player_hp,
		HealthManager.player_max_hp
	)
	update_enemy_hp(
		HealthManager.enemy_hp,
		HealthManager.enemy_max_hp
	)

	present_panel.visible = false
	
	if not InventoryUI.inventory_closed.is_connected(_on_inventory_closed):
		InventoryUI.inventory_closed.connect(_on_inventory_closed)
	
	
	
	feedback_label.visible = false
	feedback_label.text =""
	
	statement_label = get_node("StatementPanel/StatementLabel")

	await get_tree().process_frame  # IMPORTANT

	if statement_label == null:
		print(" StatementLabel NOT FOUND")
	else:
		print(" StatementLabel FOUND")

	statement_label.bbcode_enabled = true

	ui_ready = true

	player_hp_bar.max_value = HealthManager.player_max_hp
	enemy_hp_bar.max_value = HealthManager.enemy_max_hp

	player_hp_bar.value = HealthManager.player_hp
	enemy_hp_bar.value = HealthManager.enemy_hp



func _process(delta):
	if !timer_running or !timer_enabled:
		return
		
	time_left -= delta
	
	if timer_label:
		timer_label.text = str(ceil(time_left))

	if time_left <= 0:
		timer_running = false
		
		HealthManager.damage_player(10)
		flash_player_hp()
		
		await wrong_popup("TIMES UP!!")
		combat_manager.load_next_case()
# =========================
# SHOW QUESTION (FROM GAME MANAGER)
# =========================
func show_question(text: String) -> void:

	if not ui_ready:
		print(" UI not ready yet, delaying question...")

		await get_tree().process_frame
		await get_tree().process_frame

	if statement_label == null:
		print(" Still NULL after wait")
		return

	print(" SHOWING QUESTION:", text)
	statement_label.text = text
# START TIMER EVERY NEW QUESTION
	time_left = 10
	timer_running = timer_enabled

#TIMER RESET
func reset_timer():
	time_left = 10
	timer_running = timer_enabled

# =========================
# BUTTON: CHALLENGE
# =========================
func _on_btn_challenge_pressed() -> void:
#STOP TIMER WHILE PLAYER DECIDE
	timer_running = false
	
	confirm_panel.visible = true
	confirm_label.text = "Are you Sure This Argument is WRONG?"

# =========================
# BUTTON: Inventory
# =========================
func _on_btn_inventory_pressed() -> void:
	timer_running = false
	get_tree().paused = true
	InventoryUI.get_parent().visible = true
	InventoryUI.show()

func _on_inventory_closed() -> void:
	get_tree().paused = false
	timer_running = timer_enabled

# =========================
# FEEDBACK
# =========================
func show_feedback(msg):
	feedback_label.text=msg
	feedback_label.visible=true
	await get_tree().create_timer(2).timeout
	feedback_label.visible=false

func wrong_popup(message:String):
	
	feedback_label.visible = true
	feedback_label.text = message
	
	#feedback_label.scale = Vector2(3.0,3.0)
	
	#Screen effect
	position += Vector2(
		randf_range(-7,0),
		randf_range(-7,0)
	)

	await get_tree().create_timer(.15).timeout
	
	position = Vector2.ZERO
	
	await get_tree().create_timer(.8).timeout
	
	feedback_label.scale = Vector2.ONE
	feedback_label.text = ""
	feedback_label.visible = true
# =========================
# HP UPDATE
# =========================
func update_player_hp(current,maxhp):
	player_hp_bar.max_value = maxhp
	player_hp_bar.value = current

func update_enemy_hp(current,maxhp):
	enemy_hp_bar.max_value = maxhp
	enemy_hp_bar.value = current

# =========================
# PLAYER CHOSE YES
# ARGUMENT IS WRONG
# =========================
func _on_btn_yes_pressed() -> void:
	
	confirm_panel.visible=false
	
#RESET AFTER POPUPCLOSES
	reset_timer()

	await wrong_popup("YOU ARE WRONG!!")

	must_present=true

	btn_challenge.disabled=true

	btn_challenge.modulate.a=.4
# =========================
# PLAYER CHOSE NO
# ARGUMENT IS CORRECT
# =========================
func _on_btn_no_pressed() -> void:
	
	confirm_panel.visible = false

	#TIMER RESET
	reset_timer()

	var result = combat_manager.challenge_argument(
		combat_manager.current_argument,
		combat_manager.current_values)

	if result:

		show_feedback("Correct!!")

		combat_manager.load_next_case()

	else:
		HealthManager.damage_player(10)
		flash_player_hp()
		
		await wrong_popup("WRONG!!")

# ======================
# PRESENT BUTTON
# ======================
func _on_btn_present_pressed() -> void:
	if !must_present:
		show_feedback("Nothing to present")
		return

	if combat_manager.current_choices.size() < 3:
		print("ERROR: choices missing")
		return

	present_panel.visible = true

	present_label.text = "Choose the correct fix"

	choice1.text = combat_manager.current_choices[0]
	choice2.text = combat_manager.current_choices[1]
	choice3.text = combat_manager.current_choices[2]

# =========================
# CHECK PLAYER CHOICE
# =========================
func evaluate_present(answer:String):

	present_panel.visible = false

	if answer == combat_manager.current_correct_answer:
		
		HealthManager.damage_enemy(20)
		flash_enemy_hp()
		
		await wrong_popup("OBJECTION!")
		#show_feedback("Correct reasoning!")
	else:
		
		HealthManager.damage_player(10)
		flash_player_hp()
		
		await wrong_popup("WRONG!")
		#show_feedback("That evidence does not fix the argument!")

	must_present = false

	btn_challenge.disabled = false
	btn_challenge.modulate.a = 1

	await get_tree().create_timer(1).timeout

	combat_manager.load_next_case()

# =========================
# CHOICE BUTTONS
# =========================
func _on_btnchoice_1_pressed():
	evaluate_present(choice1.text)


func _on_btnchoice_2_pressed():
	evaluate_present(choice2.text)


func _on_btnchoice_3_pressed():
	evaluate_present(choice3.text)

func flash_player_hp():
	player_hp_bar.modulate = Color(1, 0.3, 0.3)

	await get_tree().create_timer(0.2).timeout
	
	player_hp_bar.modulate = player_bar_base_color

func flash_enemy_hp():
	enemy_hp_bar.modulate = Color(0.3, 1, 0.3)
	
	await get_tree().create_timer(0.2).timeout
	
	enemy_hp_bar.modulate = enemy_bar_base_color
