extends Resource
class_name ItemData

@export var item_id: String
@export var item_name: String
@export var description: String
@export var heal_amount: int = 0
@export var icon: Texture2D
@export var item_type: String = "consumable"

# USE ITEM
func use():
	if heal_amount > 0:
		HealthManager.heal_player(heal_amount)
