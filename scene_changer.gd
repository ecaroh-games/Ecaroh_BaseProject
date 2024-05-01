extends Node

func change_scene(new_scene_path:String):
	get_tree().change_scene_to_file(new_scene_path)
