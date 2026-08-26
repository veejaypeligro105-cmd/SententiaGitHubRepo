extends Node

func evaluate(expr: String, values: Dictionary) -> bool:
	print("Evaluating:", expr)
	expr = expr.strip_edges()

	#Negation
	if expr.begins_with("!"):
		return !evaluate(expr.substr(1), values)

	#And
	if "&" in expr:
		var parts = expr.split("&")
		return evaluate(parts[0], values) and evaluate(parts[1], values)

	# OR
	if "|" in expr:
		var parts = expr.split("|")
		return evaluate(parts[0], values) or evaluate(parts[1], values)

	#Implication
	if "->" in expr:
		var parts = expr.split("->")
		var p = evaluate(parts[0], values)
		var q = evaluate(parts[1], values)
		return (!p) or q
		
	# Base case(P,Q, etc.)
	return values.get(expr, false)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
