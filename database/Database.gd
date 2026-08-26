extends Node

#Admin Interface, player

var db
var used_question_ids = []
var current_user = null

func _ready():
	var target = "res://database/gamedata.db"

	if not FileAccess.file_exists(target):
		push_error("Database file missing!")
		return

	db = SQLite.new()
	db.path = target

	db.open_db()

	
	if db == null:
		push_error("DB failed to initialize")
		return

	print("DATABASE OPENED SUCCESSFULLY")

	create_tables()


func create_tables():
	var query = """
	CREATE TABLE IF NOT EXISTS questions (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		type TEXT,
		question TEXT,
		choice1 TEXT,
		choice2 TEXT,
		choice3 TEXT,
		choice4 TEXT,
		correct_card TEXT
	);

	CREATE TABLE IF NOT EXISTS users (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		email TEXT UNIQUE,
		password TEXT,
		progress INTEGER DEFAULT 0,
		item TEXT DEFAULT ''
	);
	"""
	db.query(query)

#save playername
func save_player(email: String):
	email = email.replace("'", "''")
	var query = "INSERT INTO users (email, password, progress, item) VALUES ('%s', '', 0, '')" % email
	db.query(query)
	

func get_random_question():
	var query = ""

	if used_question_ids.size() == 0:
		query = "SELECT * FROM questions ORDER BY RANDOM() LIMIT 1;"
	else:
		var ids = ""
		for i in range(used_question_ids.size()):
			ids += str(used_question_ids[i])
			if i < used_question_ids.size() - 1:
				ids += ","

		query = "SELECT * FROM questions WHERE id NOT IN (" + ids + ") ORDER BY RANDOM() LIMIT 1;"

	db.query(query)

	if db.query_result.size() > 0:
		var row = db.query_result[0]

		return {
			"id": row["id"],
			"type": row["type"],
			"question": row["question"],
			"choices": [
				row["choice1"],
				row["choice2"],
				row["choice3"],
				row["choice4"]
			],
			"correct_card": row["correct_card"]
		}

	return null

func mark_question_used(id):
	if id not in used_question_ids:
		used_question_ids.append(id)
