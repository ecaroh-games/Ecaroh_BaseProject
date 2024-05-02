extends Node

#@onready var song1 = $AudioStreamPlayer as AudioStreamPlayer

var songs = []
var current_song:int = 0

var db_silent = -42.0
var db_playing = 0.0

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is AudioStreamPlayer:
			songs.append(child)
			
	print(songs)
	switch_song(1)
	pass # Replace with function body.
	
func switch_song(new_song:int, fade_time := 1.23):
	if new_song != current_song:
		songs[new_song].play()
		songs[new_song].volume_db = db_silent
		
		if tween:
			tween.kill()
		tween = create_tween().set_parallel()
		tween.tween_property(songs[current_song], "volume_db", db_silent, fade_time * 1.5)
		tween.tween_property(songs[new_song], "volume_db", db_playing, fade_time)
		
		await tween.finished
		
		songs[current_song].stop()
		current_song = new_song

func _input(event):
	if Input.is_action_just_pressed("debug_music"):
		if current_song == 1:
			switch_song(2)
		else:
			switch_song(1)
		
