@icon("res://ASSETS/ICONS/laser-sparks.png")
class_name FlashFrames extends Node

@export var flashSprite:Node2D

var flashDuration:float
var flashCountMax:int

var flashColor:Color
var flashColor2:Color
var defaultColor:Color

var flashCount = 0
var flashStarted = false
var flash_toggle = false

func flash(dur:float = 1.0, flashes:int = 12, col:Color = Color.RED * 2.3, col2:Color = Color.WHITE * 2.3) -> void:
	if flashStarted:
		flashCount = 0
		flashSprite.modulate = defaultColor
		$Timer.stop()

	flashStarted = true
	defaultColor = flashSprite.modulate
	$Timer.wait_time = dur / flashes
	flashCount = 0
	flashCountMax = flashes
	flashColor = col
	flashColor2 = col2
	flash_toggle = false
	$Timer.start()

func _on_timer_timeout() -> void:
	flashCount += 1
	if flashCount <= flashCountMax:
		flash_toggle = !flash_toggle
		match flash_toggle:
			true:
				flashSprite.modulate = flashColor
			false:
				flashSprite.modulate = flashColor2
		$Timer.start()
	else:
		flashStarted = false
		flashCount = 0
		flashSprite.modulate = defaultColor
		$Timer.stop()
	
func stop_flash() -> void:
	if flashStarted:
		flashStarted = false
		flashCount = 0
		flashSprite.modulate = defaultColor
		$Timer.stop()


func _on_hurtbox_got_hit(_source):
	flash(0.23, 6)
	pass # Replace with function body.
