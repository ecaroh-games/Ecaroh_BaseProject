class_name DialogueDisplay extends Node2D

@export var write_speed = 1.0
@export var delay_duration = 3.0
@export var erase_duration = 3.0

@export var start_pitch = 1.23
@export var pitch_var = 2.0

var time_per_letter 

var format_Latrommi = "[color=#6750a6][wave  freq=6.9 amp=-12.3 connected=1]Latrommi[/wave][/color]"
var format_Ecaroh = "[color=#e91cb7][wave  freq=6.9 amp=12.3 connected=1]Ecaroh[/wave][/color]"
var format_Ekaj = "[color=#a4514d][wave  freq=6.9 amp=12.3 connected=1]Ekaj[/wave][/color]"
var format_Kelfric = "[color=#ffc869][wave  freq=6.9 amp=12.3 connected=1]Kelfric[/wave][/color]"
var format_Melgmir = "[color=#3dffc7][wave  freq=6.9 amp=12.3 connected=1]Melgmir[/wave][/color]"
var format_SHIFT = "[color=#FF0000][wave  freq=6.9 amp=12.3 connected=1]SHIFT KEY[/wave][/color]"

var message_queue = []

@onready var dialogue_window = $DialogueWindow2

var tweenRef:Tween

signal done_dialogue()

var test_message = [
	"{E} - {L} - {J} - {K} - {M}",
	"Testing {E}",
	"Testing {L}",
	"Testing {J}",
	"Testing {K}",
	"Testing {M}"
]

var state := "hidden"
# hidden, writing, waiting, erasing

func _ready() -> void:
	dialogue_window.text = ""
	$EnterKey.visible = false
	#var new_message = "Greetings, {E}! It's so good to see you again. {L} must have sent you..."
	#var formatted = new_message.format({"L": format_Latrommi, "E": format_Ecaroh})
	#write_message(format_text(new_message))
	
	
	#add_message("hello world")
	#add_message(test_message)
	#write_next_message()
	pass # Replace with function body.

#func _process(_delta) -> void:


func add_message(new_text) -> void:
	if new_text is String:
		message_queue.push_back( format_text(new_text) )
	elif new_text is Array:
		for i in new_text.size():
			message_queue.push_back( format_text(new_text[i]) ) 
	if $writeTimer.is_stopped() and (state == "erasing" or state == "hidden"):
		write_next_message()

func write_next_message() -> void:
	state = "writing"
	hide_skip_button()
	#$eraseTimer.stop()
	#$delayTimer.stop()
	if tweenRef != null:
		modulate = Color.WHITE
		tweenRef.stop()

	dialogue_window.text = message_queue[0]
	dialogue_window.visible_ratio = 0
	time_per_letter = write_speed / 12.23
	$writeTimer.wait_time = time_per_letter
	$writeTimer.start()
	message_queue.pop_front()

func write_letter() -> void:
	#print(text[get_visible_characters()])
	$sfx_type.pitch_scale = start_pitch + dialogue_window.visible_ratio * pitch_var
	$sfx_type.play()
	dialogue_window.visible_ratio += 1.0 / dialogue_window.get_total_character_count()

func format_text(text:String) -> String:
	var formatted = text.format({
		"L": format_Latrommi,
		"E": format_Ecaroh,
		"J": format_Ekaj,
		"K": format_Kelfric,
		"M": format_Melgmir,
		"S": format_SHIFT,
		})
	var centertag = "[center]"
	var wavetag = "[wave  freq=2.3 amp=23 connected=0]"
	var wavetag_close = "[/wave]"
	var centertag_close = "[/center]"
	#return centertag + wavetag + formatted + wavetag_close + centertag_close
	return wavetag + formatted + wavetag_close

func _on_write_timer_timeout() -> void:
	if dialogue_window.visible_ratio < 1.0:
		write_letter()
	else:
		end_writing()
		
func end_writing() -> void:
	state = "waiting"
	$writeTimer.stop()
	$sfx_skip.play()
	dialogue_window.visible_ratio = 1
	display_skip_button()

func erase_text() -> void:
	$sfx_done.play()
	state = "erasing"
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, erase_duration).set_ease(Tween.EASE_OUT)
	tweenRef = tween
	await tween.finished
	done_dialogue.emit()
#
#waiting (end)
func _on_delay_timer_timeout() -> void:
	#if message_queue.size() == 0:
		#$eraseTimer.start(erase_duration)
	#else:
		#write_next_message()
	pass # Replace with function body.

#erasing
func _on_erase_timer_timeout() -> void:
	#if message_queue.size() == 0:
		#state = "erasing"
		#var tween = create_tween()
		#tween.tween_property(self, "modulate", Color.TRANSPARENT, erase_duration).set_ease(Tween.EASE_OUT)
		#tweenRef = tween
	#else:
		#write_next_message()
	pass
	
func hide_skip_button() -> void:
	$EnterKey.visible = false

func display_skip_button() -> void:
	$EnterKey.visible = true
	var lines = dialogue_window.get_line_count()
	var w = dialogue_window.get_content_width()
	#$EnterKey.position.y = 70 + 30 * (lines - 1)
	
func _input(_event) -> void:
	if Input.is_action_just_pressed("space"):
		match state:
			"writing" : end_writing()
			"waiting" : 
				if message_queue.size() == 0:
					erase_text()
				else:
					write_next_message()
			"erasing" : return
	pass
