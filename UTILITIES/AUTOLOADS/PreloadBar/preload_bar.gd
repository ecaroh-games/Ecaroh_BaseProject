extends CanvasLayer

@onready var progress_bar = $ProgressBarTotal as ProgressBar
@onready var progress_bar_small = $ProgressBarSmall as ProgressBar
@onready var message = $Label as Label

func _ready():
	visible = false

func set_message(msg:String):
	message.text = msg
	
func update_global_progress(progress:float):
	progress_bar.value = progress
	
func update_current_progress(progress:float):
	progress_bar_small.value = progress

#func set_visible(toggle:bool):
	#visible = toggle
