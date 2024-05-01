@icon("ico_hurtbox.png")
class_name Hurtbox extends Area2D

@export var permanent = true

signal got_hit(source:Hitbox)

func _ready() -> void:
	if permanent:
		toggle(true)
	else:
		toggle(false)

func vulnerable(duration:float) -> void:
	toggle(true)
	$Timer.start(duration)

func _on_timer_timeout() -> void:
	toggle(false)
	pass # Replace with function body.

func toggle(toggle_hurtbox:bool) -> void:
	visible = toggle_hurtbox
	set_deferred("monitorable", toggle_hurtbox)
	set_deferred("monitoring", toggle_hurtbox)

func hurt(source:Hitbox) -> void:
	got_hit.emit(source)
