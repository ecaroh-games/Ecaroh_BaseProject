class_name SceneFade extends CanvasLayer


signal done()

@onready var rect = $ColorRect as ColorRect

var tween

func _ready():
	rect.modulate = Color.TRANSPARENT

func fade_to_black():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 0.23)
	await tween.finished
	done.emit()
	
func fade_away():
	if tween:
		tween.kill()
	tween = create_tween().set_parallel()
	tween.tween_property(rect, "modulate:a", 0.0, 0.23)
