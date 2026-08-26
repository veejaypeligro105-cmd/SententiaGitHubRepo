extends Node2D

var card_in_slot = false
var current_card = null

signal card_played(card)

func place_card(card):
	card_in_slot = true
	current_card = card
	emit_signal("card_played", card)

func remove_card():
	card_in_slot = false
	current_card = null
