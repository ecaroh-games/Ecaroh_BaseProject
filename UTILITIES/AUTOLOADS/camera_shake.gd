extends Node

var tween

func shake(amt := 23.0, shakes := 3):
	var cam = get_viewport().get_camera_2d()
	if cam:
		if tween:
			tween.kill()
		tween = create_tween()
		for i in range(shakes):
			var ratio = float(i) / shakes
			tween.tween_property(cam, "offset", Vector2(randf_range(-amt, amt), randf_range(-amt, amt)) * (1.0 - ratio), 0.023 + 0.123 * ratio)
