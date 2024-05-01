extends Node

@onready var song1 = $AudioStreamPlayer as AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func switch_song(new_song:int = 1):
	song1.play()
	pass

func _process(_delta):
	if !song1.playing:
		song1.play()
		set_process(false)
