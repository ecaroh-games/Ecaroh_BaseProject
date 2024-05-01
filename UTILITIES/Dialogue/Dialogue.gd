extends Node2D

@export var write_speed = 1.0
@export var delay_duration = 3.0
@export var erase_duration = 0.5
var time_per_letter 

var format_A = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Arrow Keys or WASD[/wave][/color]"
var format_B = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Right Click[/wave][/color]"
var format_C = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Left Click[/wave][/color]"

var format_P = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Power Crystals[/wave][/color]"
var format_T = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Tower[/wave][/color]"
var format_H = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Helpers[/wave][/color]"
var format_E = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Electrons[/wave][/color]"
var format_L = "[color=#9efffd][wave  freq=6.9 amp=-12.3 connected=1]Lumboco's Law[/wave][/color]"

var tutorial_message = [
	"Use {A} to move.",
	"Use {B} to summon {H}.",
	
	"Stand near the {P} to charge Ecaroh's {T}.",
	#"When Ecaroh's {T} is powered, it will generate empty {E}.",
	"Use {C} to spawn uncharged {E}.",
	"{H} will power up nearby {P} too.",
	#"{H} automatically spawn charged {E}.",
	#"But will also attract monsters towards them...",
	#"Remember {L}. Empty {E} will repel each other.",
	#"Empty {E} will be attracted to charged {E} and {P} alike.",
	"Charged {E} explode when they hit monsters!"
]


var message_queue = []

@onready var dialogue_window:RichTextLabel = $RichTextLabel

var tween:Tween

var state := "hidden"
# hidden, writing, waiting, erasing

func _ready() -> void:
	$TextWin.visible = false
	dialogue_window.text = ""
	#add_message(tutorial_message)

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
	dialogue_window.text = message_queue[0]
	dialogue_window.visible_ratio = 0
	time_per_letter = write_speed / 12.23
	$writeTimer.wait_time = time_per_letter
	$writeTimer.start()
	message_queue.pop_front()


func write_letter() -> void:
	$sfx_type.play()
	dialogue_window.visible_ratio += 1.0 / dialogue_window.get_total_character_count()

func format_text(text:String) -> String:
	var formatted = text.format({
		"A": format_A,
		"B": format_B,
		"C": format_C,
		"P": format_P,
		"T": format_T,
		"H": format_H,
		"E": format_E,
		"L": format_L
		})
	var centertag = "[center]"
	var wavetag = "[wave  freq=2.3 amp=23 connected=0]"
	var wavetag_close = "[/wave]"
	var centertag_close = "[/center]"
	return centertag + wavetag + formatted + wavetag_close + centertag_close

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
	#if TutorialTracker.questing:
		#$TextTutorial.visible = true

func erase_text() -> void:
	#$sfx_done.play()
	state = "erasing"
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(dialogue_window, "modulate", Color.TRANSPARENT, erase_duration).set_ease(Tween.EASE_OUT)
	$TextWin.visible = true
	tween.tween_property($TextWin, "modulate", Color.WHITE, erase_duration).set_ease(Tween.EASE_OUT)

#func _input(_event) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#match state:
			#"writing" : end_writing()
			#"waiting" : 
				#if message_queue.size() == 0:
					#erase_text()
				#else:
					#write_next_message()
			#"erasing" : return
	#pass
	
func display_tutorial(message:String):
	$TextTutorial.text = format_text(message)
	
func display_win_condition(message:String):
	var centertag = "[right]"
	var wavetag = "[wave  freq=2.3 amp=23 connected=0]"
	var wavetag_close = "[/wave]"
	var centertag_close = "[/right]"
	$TextWin.text = centertag + wavetag + message + wavetag_close + centertag_close
	
func continue_tutorial():
	if message_queue.size() == 0:
		$TextSkip.visible = false
		erase_text()
	else:
		write_next_message()
	
func clear_tutorial():
	$TextTutorial.visible = false
	
func skip_tutorial():
	end_writing()
	erase_text()
	$TextTutorial.visible = false
	$TextSkip.visible = false
