@icon("ico_hitbox.png")
class_name Hitbox extends Area2D

@export var damage = 1.0
@export var permanent = false
@export var splash_damage = false
@export var knockback = true
@export var knockbackStrength = 123.0
@export var tag:String

signal hit_target(target_area:Area2D)

func _ready() -> void:
	if permanent:
		toggle(true)
	else:
		toggle(false)

func attack(duration:float) -> void:
	toggle(true)
	$Timer.start(duration)

func _on_timer_timeout() -> void:
	toggle(false)
	pass # Replace with function body.

func toggle(toggle_hitbox:bool) -> void:
	visible = toggle_hitbox
	set_deferred("monitorable", toggle_hitbox)
	set_deferred("monitoring", toggle_hitbox)

func _on_area_entered(area:Hurtbox) -> void:
	hit_target.emit(area)
	if area.has_method("hurt"):
		area.hurt(self)
