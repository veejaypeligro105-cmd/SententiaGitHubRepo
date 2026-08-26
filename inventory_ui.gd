extends CanvasLayer

@onready var item_list = $Inventory_UI/Panel/ItemList
@onready var description_label = $Inventory_UI/Panel/Descriptionlabel/Descriptionlabel
@onready var usebtn = $Inventory_UI/Panel/Use
@onready var closebtn = $Inventory_UI/Panel/Close

var selected_item = null

signal inventory_closed

func _ready() -> void:
	add_to_group("InventoryUI")
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()
	Inventory.inventory_changed.connect(update_ui)
	usebtn.pressed.connect(_on_use_pressed)
	closebtn.pressed.connect(_on_close_pressed)
	update_ui()

func update_ui() -> void:
	for child in item_list.get_children():
		child.queue_free()
	for id in Inventory.get_items():
		var data = Inventory.items[id]
		var item = data["item"]
		var qty = data["quantity"]
		var btn = Button.new()
		btn.text = "%s x%d" % [item.item_name, qty]
		btn.pressed.connect(func():
			select_item(item)
		)
		item_list.add_child(btn)

func select_item(item: ItemData) -> void:
	selected_item = item
	description_label.text = item.description

func _on_use_pressed() -> void:
	if selected_item == null:
		return
	print("USING:", selected_item.item_name)
	selected_item.use()
	if selected_item.item_type == "consumable":
		Inventory.remove_item(selected_item)
	selected_item = null
	description_label.text = ""
	update_ui()

func _on_close_pressed() -> void:
	get_tree().paused = false
	emit_signal("inventory_closed")
	hide()
