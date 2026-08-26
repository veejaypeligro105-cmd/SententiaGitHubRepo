extends Resource
class_name QuestionData

@export var statement_text: String
@export var is_true: bool
@export var choices: Array[String] = [] #only used when is_true == false
@export var correct_choice: String = "" #must exactly match one entry in choices
