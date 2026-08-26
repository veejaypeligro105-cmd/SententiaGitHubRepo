extends Node

var MaxHP
var CurrentHP

@export var HealthNode: int;

#@onready var HealthNode = $HealthNode

signal Death

func TakeDamage(amount,_type):
	CurrentHP = clampf(CurrentHP - amount, 0, MaxHP)
	if CurrentHP <= 0:
		Death.emit()
