extends Control

@onready var gold_label = $HBoxContainer/CoinIcon/goldlabel
@onready var coin_icon = $HBoxContainer/CoinIcon

var t := 0.0

func _ready() -> void:
	GameManager.gold_changed.connect(update_gold)
	update_gold()

	if coin_icon.has_method("play"):
		coin_icon.play("spin")

func update_gold():
	gold_label.text = str(GameManager.gold)

func _process(delta: float) -> void:
	t += delta
	scale = Vector2.ONE * (1.0 + sin(t * 3.0) * 0.05)
