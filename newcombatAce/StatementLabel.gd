extends RichTextLabel

var full_text: String = ""
var speed: float = 0.03
var is_typing: bool = false
var skip_requested: bool = false

func show_text(text: String):
	full_text = text
	self.text = ""
	is_typing = true
	skip_requested = false
	reveal_text()

func reveal_text():
	for i in full_text.length():
		if skip_requested:
			self.text = full_text
			break
			
		self.append_text(full_text[i])
		await get_tree().create_timer(speed).timeout
		
	is_typing = false

func _input(event):
	if is_typing and event is InputEventKey and event.is_action_pressed("ui_accept"):
		skip_requested = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
