extends Sprite2D

var duration:float
var start_color:Color

var src:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(duration)
	var tween = create_tween()
	modulate = Color(start_color.r, start_color.g, start_color.b, 0.69)
	tween.tween_property(self, "modulate", Color(start_color.r, start_color.g, start_color.b, 0.0), duration).set_ease(Tween.EASE_OUT)
	pass # Replace with function body.

func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.

func init(color:Color, dur:float):
	start_color = color
	duration = dur
