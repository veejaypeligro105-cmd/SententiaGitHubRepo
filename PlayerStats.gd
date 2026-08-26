extends Node

var MaxHP:float = 100
var CurrentHP:float
var Str:int = 5
var Dex:int = 3
var Int:int = 2

var Skills:Array[Resource]

var Experience:int
var Level:int

func _ready():
	for skill in [
		"res://Skills/Attack.tres",
		"res://Skills/S_Attack.tres",
		"res://Skills/Fireball.tres",
		"res://Skills/Lester_Attack.tres"
		]:
		var CurrentSkill = load(skill)
		Skills.append(CurrentSkill)
