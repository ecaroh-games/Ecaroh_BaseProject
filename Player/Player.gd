@icon("res://ASSETS/ICONS/ecaroh_icon3.png")

class_name Player extends Node2D

func _physics_process(delta):
	position = get_global_mouse_position()


func _on_hitbox_hit_target(target_area):
	print("hit")
	pass # Replace with function body.
