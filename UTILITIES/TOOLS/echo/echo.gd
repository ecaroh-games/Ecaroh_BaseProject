extends Sprite2D

var duration:float
var start_color:Color

var src:Node2D

func init(color:Color, dur:float):
	start_color = color
	modulate = start_color
	duration = dur

func _ready():
	var tween = create_tween()
	modulate = Color(start_color.r, start_color.g, start_color.b, 0.69)
	tween.tween_property(self, "modulate", Color(start_color.r, start_color.g, start_color.b, 0.0), duration).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	queue_free()
	pass # Replace with function body.
