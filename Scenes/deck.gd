extends Node2D

#Note in collision on Area2D in Collision 1 is Card 2, is card Slots is 2, and 3 is Deck
const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_DRAW_SPEED = 0.1


var player_deck = ["Knight","Archer","Demon"]

var card_database_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://Scenes/CardDatabase.gd")
