extends Node

@onready var scene_fade:SceneFade

func _ready():
	scene_fade = load("res://SCENES/_transition/scene_fade.tscn").instantiate()
	add_child(scene_fade)

func change_scene(new_scene_path:String):
	print("switching scene to --> " + str(new_scene_path))
	print("fading out")
	scene_fade.fade_to_black()
	await scene_fade.done
	print("switch scene")
	get_tree().change_scene_to_file(new_scene_path)
	print("fading back in")
	scene_fade.fade_away()
