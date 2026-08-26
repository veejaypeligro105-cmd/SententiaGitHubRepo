@tool
extends EditorScript

func _run() -> void:
	_generate_floor1()
	_generate_floor2()
	print("Question pools generated.")

func _generate_floor1() -> void:
	var pool := QuestionPool.new()
	pool.pool_id = "Floor1"
	pool.cases = [
		_case("If P → Q and P are true, then Q must also be true in a valid argument.", true, [], ""),
		_case("An argument is sound if it is valid and all premises are true.", true, [], ""),
		_case("A weak argument always guarantees that the conclusion is certainly true.", false,
			["It has little support for the conclusion", "It has many premises", "It contains no evidence"],
			"It has little support for the conclusion"),
		_case("Deductive arguments are evaluated based on validity.", true, [], ""),
		_case("Inductive arguments always provide absolute certainty like deductive arguments.", false,
			["Possibility only", "Absolute certainty", "Mathematical proof"],
			"Possibility only"),
		_case("A cogent argument is a strong inductive argument with true premises.", true, [], ""),
		_case("Invalid arguments can never produce a true conclusion under any condition.", false,
			["They may still have true conclusions", "They are always sound", "They contain no premises"],
			"They may still have true conclusions"),
		_case("A conclusion is the statement supported by the premises.", true, [], ""),
		_case("Premises are reasons used to support a conclusion.", true, [], ""),
		_case("Every valid argument is automatically sound regardless of whether the premises are true.", false,
			["Impossible", "Only if there is no conclusion", "If one or more premises are false"],
			"If one or more premises are false"),
	]
	ResourceSaver.save(pool, "res://QUESTIONFILE/floor1_cases.tres")

func _generate_floor2() -> void:
	var pool := QuestionPool.new()
	pool.pool_id = "Floor2"
	pool.cases = [
		_case("P → Q, P, ∴ Q is an example of Modus Tollens.", false,
			["Modus Tollens", "Modus Ponens", "Hypothetical Syllogism"],
			"Modus Ponens"),
		_case("In a categorical syllogism, there are usually three terms.", true, [], ""),
		_case("P ∨ Q, P, ∴ Q is always a valid disjunctive syllogism.", false,
			["It is invalid", "It is Modus Ponens", "It is hypothetical reasoning"],
			"It is invalid"),
		_case("A hypothetical syllogism follows the form: P → Q, Q → R, ∴ R → P.", false,
			["If P then not Q", "If P then R", "If R then P"],
			"If P then R"),
		_case("Circular arguments repeat the conclusion as evidence.", true, [], ""),
		_case("\"All mammals are animals. Dogs are mammals. Therefore, dogs are animals.\" is a categorical syllogism.", true, [], ""),
		_case("A disjunctive argument uses only conjunctions such as P∧Q.", false,
			["\"If-then\" only", "Questions only", "\"Either-or\" statements"],
			"\"Either-or\" statements"),
		_case("The symbolic form P ∧ Q is called a conditional statement.", false,
			["Conjunction statement", "Conditional statement", "Biconditional statement"],
			"Conjunction statement"),
		_case("A fallacy is a mistake in reasoning.", true, [], ""),
		_case("Argument structures are patterns used to organize reasoning.", true, [], ""),
	]
	ResourceSaver.save(pool, "res://QUESTIONFILE/floor2_cases.tres")

func _case(text: String, is_true: bool, choices: Array[String], correct: String) -> QuestionData:
	var c := QuestionData.new()
	c.statement_text = text
	c.is_true = is_true
	c.choices = choices
	c.correct_choice = correct
	return c
