extends Control

@onready var popup_panel: Panel = $TutorialPopup
@onready var popup_label: Label = $TutorialPopup/TutorialLabel
@onready var next_btn : Button = $TutorialPopup/TutorialNextBtn

@onready var btn_challenge: Button = $"../ButtonContainer/BtnChallenge"
@onready var btn_present: Button = $"../ButtonContainer/BtnPresent"
@onready var btn_inventory: Button = $"../ButtonContainer/BtnInventory"
@onready var btn_yes: Button = $"../ConfirmationPanel/BtnYes"
@onready var btn_no: Button = $"../ConfirmationPanel/BtnNo"
@onready var choice1: Button = $"../PresentPanel/Btnchoice1"
@onready var choice2: Button = $"../PresentPanel/Btnchoice2"
@onready var choice3: Button = $"../PresentPanel/Btnchoice3"

var step := 0

var steps := [
	{
		"text": "Welcome to Combat System! Every fight starts with a STATEMENT — an argument you need to judge. Read it, then press Proceed.",
		"enable": [],
		"advance_on": "manual"
	},
	{
		"text": "See something wrong with it? Press CHALLENGE to call it out ",
		"enable": ["challenge"],
		"advance_on": "challenge"
	},
	{
		"text": "This one's a classic fallacy. Press YES — you're sure it's wrong. (In a real battle you'd judge this yourself.)",
		"enable": ["yes"],
		"advance_on": "yes"
	},
	{
		"text": "Now back it up. Press PRESENT to bring up your evidence.",
		"enable": ["present"],
		"advance_on": "present"
	},
	{
		"text": "Pick the statement that's actually valid here.",
		"enable": ["choice1","choice2","choice3"],
		"advance_on": "choice"
	},
	{
		"text": "Nice work! One more thing — INVENTORY lets you check your items mid-fight. Try opening it now.",
		"enable": ["inventory"],
		"advance_on": "inventory"
	},
	{
		"text": "That's the whole loop: read the statement, Challenge if it's wrong, Present your fix, and check Inventory whenever you need to. You're ready for real battles!",
		"enable": [],
		"advance_on": "manual",
		"final": true
	}
]

func _ready() -> void:
	next_btn.pressed.connect(_on_next_pressed)
	
	btn_challenge.pressed.connect(func(): _try_advance("challenge"))
	btn_yes.pressed.connect(func(): _try_advance("yes"))
	btn_present.pressed.connect(func(): _try_advance("present"))
	choice1.pressed.connect(func(): _try_advance("choice"))
	choice2.pressed.connect(func(): _try_advance("choice"))
	choice3.pressed.connect(func(): _try_advance("choice"))
	btn_inventory.pressed.connect(func(): _try_advance("inventory"))

	_show_step(0)

func _disable_all() -> void:
	for b in [btn_challenge, btn_present, btn_inventory, btn_yes, btn_no, choice1, choice2, choice3,]:
		b.disabled = true
		b.modulate.a = 0.4

func _enable_only(names: Array) -> void:
	var name_to_btn := {
		"challenge": btn_challenge,
		"present": btn_present,
		"inventory": btn_inventory,
		"yes": btn_yes,
		"choice1": choice1,
		"choice2": choice2,
		"choice3": choice3,
	}
	_disable_all()
	for n in names:
		if name_to_btn.has(n):
			var b = name_to_btn[n]
			b.disabled = false
			b. modulate.a = 1.0
			
func _show_step(index: int) -> void:
	step = index
	var data = steps[step]
	popup_panel.visible = true
	popup_label.text = data["text"]
	_enable_only(data["enable"])
	next_btn.visible = data["advance_on"] == "manual"
	
func _on_next_pressed() -> void:
	if steps[step].get("final", false):
		get_tree().paused = false
#====================================================================
		SceneManager.goto_scene_id("") #PUT THE SCENE IN HERE VEEJAY
#====================================================================
		return
	_advance()
	
func _try_advance(trigger: String) -> void:
	if steps[step]["advance_on"] != trigger:
		return
	popup_panel.visible = false
	await get_tree().create_timer(0.4).timeout
	_advance()

func _advance() -> void:
	step += 1
	if step >= steps.size():
		return
	_show_step(step)
