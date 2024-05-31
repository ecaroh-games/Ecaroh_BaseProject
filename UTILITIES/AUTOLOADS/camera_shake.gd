extends Node

var tween
var cam:Camera2D

func reset_camera():
	cam = get_viewport().get_camera_2d()
	pass

func shake(amt := 23.0, shakes := 3):
	if cam != null:
		if tween:
			tween.kill()
			cam.offset = Vector2.ZERO
		tween = create_tween()
		for i in range(shakes):
			var ratio = float(i) / shakes
			tween.tween_property(cam, "offset", Vector2(randf_range(-amt, amt), randf_range(-amt, amt)) * (1.0 - ratio), 0.023 + 0.123 * ratio)
