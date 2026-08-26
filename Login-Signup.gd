extends Control

@onready var email_input = $Panel/EmailInput
@onready var password_input = $Panel/PasswordInput
@onready var loginbtn = $Panel/LoginButton
@onready var signupbtn = $Panel/SignupButton
@onready var statuslbl = $Panel/Statuslbl

func _ready() -> void:
	loginbtn.pressed.connect(_on_login_button_pressed)
	signupbtn.pressed.connect(_on_signup_button_pressed)
	statuslbl.text = ""



# LOGIN 
func _on_login_button_pressed() -> void:
	var email = email_input.text.strip_edges().to_lower()
	var password = password_input.text.strip_edges().to_lower() 

	if email == "" or password == "":
		statuslbl.text = "Please enter email and password."
		return

	Database.db.query("SELECT * FROM users WHERE email = '%s'" % email)

	print("=== USERS FOUND ===")
	print(Database.db.query_result)

	if Database.db.query_result.size() == 0:
		statuslbl.text = "Account not found"
		return

	var user = Database.db.query_result[0]

	var db_password = str(user["password"]).strip_edges().to_lower()
	var input_password = password

	print("DB PASSWORD:", db_password)
	print("INPUT PASSWORD:", input_password)

	if db_password == input_password:
		statuslbl.text = "Login successful!"
		Database.current_user = user
		SceneManager.goto_scene("res://startup_menu.tscn", false)
	else:
		statuslbl.text = "Wrong password"



# SIGNUP (FIXED)
func _on_signup_button_pressed() -> void:
	var email = email_input.text.strip_edges().to_lower()
	var password = password_input.text.strip_edges().to_lower() 

	if email == "" or password == "":
		statuslbl.text = "Fill all fields."
		return

	if password.length() < 6:
		statuslbl.text = "Password must be at least 6 characters."
		return

	Database.db.query("SELECT * FROM users WHERE email = '%s'" % email)

	if Database.db.query_result.size() > 0:
		statuslbl.text = "Email already exists!"
		return

	var query = "INSERT INTO users (email, password, progress, item) VALUES ('%s', '%s', 0, '')" % [email, password]
	Database.db.query(query)

	statuslbl.text = "Account created successfully!"
	print("USER CREATED:", email)
