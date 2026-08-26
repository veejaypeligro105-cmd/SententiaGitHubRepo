extends Resource
class_name Argument

@export var premises: Array = []
@export var conclusion: String = ""

func is_valid(engine, values: Dictionary) -> bool:
	var all_premises_true = true

	for p in premises:
		if not engine.evaluate(p, values):
			all_premises_true = false

	var conclusion_true = engine.evaluate(conclusion, values)

	return !(all_premises_true and !conclusion_true)
