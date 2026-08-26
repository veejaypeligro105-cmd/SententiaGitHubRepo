extends Label

var float_speed := 60
var fade_speed := 2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.RED
	modulate.a = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= float_speed * delta
	
	modulate.a -= fade_speed * delta
	
	if modulate.a <= 0:
		queue_free()
