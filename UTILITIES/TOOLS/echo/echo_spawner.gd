@icon("res://ASSETS/ICONS/amplitude.png")
class_name EchoSpawner extends Node2D

var echo_scene = preload("res://UTILITIES/TOOLS/echo/echo.tscn")

func spawn_echo(src:Node2D, echo_resource:EchoResource):
	if "Anim" in src:
		var anim = src.Anim as AnimatedSprite2D
		var echo_instance = echo_scene.instantiate()
		echo_instance.texture = anim.sprite_frames.get_frame_texture(anim.animation, anim.frame)
		echo_instance.flip_h = anim.flip_h
		echo_instance.flip_v = anim.flip_v
		if src != anim:
			echo_instance.scale = src.scale * anim.scale
		else:
			echo_instance.scale = anim.scale
		echo_instance.position = src.position
		echo_instance.init(echo_resource.start_color, echo_resource.duration)
		add_child(echo_instance)
	else:
		print("no source sprite -- no echo")
	pass
