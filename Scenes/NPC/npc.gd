extends CharacterBody3D

@onready var animated_sprite = $AnimatedSprite3D

#@onready var camera: Camera3D = get_viewport().get_camera_3d()

#Dialogue Settings
@export var dialogue_resource: Resource
@export var intro_dialogue: Resource
@export var repeat_dialogue: Resource
@export var dialogue_start: String = "start"


#State of the Dialogue
var has_shown_intro := false

func _process(delta: float) -> void:
	

	#if camera == null:
		#return
#
	#var dir = camera.global_position - global_position
	#dir.y = 0
#
	#if dir.length() == 0:
		#return
#
	#animated_sprite.rotation.y = atan2(dir.x, dir.z)
	pass
func _ready():
	add_to_group("npc")
	animated_sprite.play("Npc-Idle")

#func _physics_process(delta: float) -> void:
	#if animated_sprite.animation != "Npc-Idle":
		#animated_sprite.play("Npc-Idle")

#Main Interaction
func interact():
	
	#Only one dialogue
	if dialogue_resource:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		return
	
	#Intro (Dialogues with intro and repeatable 2nd dialogue)
	if not has_shown_intro:
		if intro_dialogue:
			DialogueManager.show_example_dialogue_balloon(intro_dialogue, dialogue_start)
		has_shown_intro = true
		return

#repeat dialogue
	if repeat_dialogue:
		DialogueManager.show_example_dialogue_balloon(repeat_dialogue, dialogue_start)


#func NPC():
	#pass
