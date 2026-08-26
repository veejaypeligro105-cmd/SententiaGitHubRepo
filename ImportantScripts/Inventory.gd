extends Node

signal inventory_changed

var items: Dictionary = {}

var _starter_items_given := false

func _ready():
	if _starter_items_given:
		return
	_starter_items_given = true
	
	var Candy = preload("res://ItemsResource/CandyHp.tres")
	var Coffee = preload("res://ItemsResource/Coffee.tres")
	var Potion = preload("res://ItemsResource/Potion.tres")

	add_item(Coffee)
	add_item(Candy)
	add_item(Potion)
	add_item(Coffee) # test stacking

# ADD ITEM (STACK SYSTEM)
func add_item(item: ItemData):
	var id = item.item_name 

	if items.has(id):
		items[id]["quantity"] += 1
	else:
		items[id] = {
			"item": item,
			"quantity": 1
		}

	emit_signal("inventory_changed")

# REMOVE ITEM (STACK SYSTEM)
func remove_item(item: ItemData):
	var id = item.item_name

	if not items.has(id):
		return

	items[id]["quantity"] -= 1

	if items[id]["quantity"] <= 0:
		items.erase(id)

	emit_signal("inventory_changed")

func clear():
	items.clear()
	emit_signal("inventory_changed")

func get_items():
	return items
