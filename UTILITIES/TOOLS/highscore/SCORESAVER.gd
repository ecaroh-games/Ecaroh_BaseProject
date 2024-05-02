extends Node

var score:int = 0
var highscore:int = 0

var save_path:String = "user://file_score1.save"

var player_name:String
var name_path:String = "user://file_name1.save"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_file()
	load_name()
	
func add_points(amt:int) -> void:
	score += amt
	
func restart_game() -> void:
	score = 0

func save(override := false) -> void:
	print("Your score: "+ str(score))
	if score > highscore || override:
		highscore = score
		print("New high score!! " + str(highscore))
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(highscore)
		file.close()
		print("[Score saved]")
	
func load_file() -> void:
	if FileAccess.file_exists(save_path):
		print("[File found]")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var loaded_highscore = file.get_var()
		highscore = loaded_highscore
		print("Loaded high score : "+str(highscore))
	else:
		print("[File not found]")
		highscore = 0

func save_name(new_name:String) -> void:
	player_name = new_name
	print("Your name: "+ str(player_name))
	var file = FileAccess.open(name_path, FileAccess.WRITE)
	file.store_var(new_name)
	file.close()
	print("[Name saved]")

func load_name() -> void:
	if FileAccess.file_exists(name_path):
		print("[Name found]")
		var file = FileAccess.open(name_path, FileAccess.READ)
		player_name = file.get_var()
		print("Loaded name: "+str(player_name))
	else:
		print("[Name not found]")
		player_name = "username"
