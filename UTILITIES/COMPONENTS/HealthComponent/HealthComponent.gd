extends Node2D

@export var hp:int = 23
@onready var max_hp := hp

signal hp_changed(ratio:float)
signal hp_set(max_hp:int)
signal died()

func _ready():
	hp_set.emit(max_hp)

func hurt(amt:int):
	hp = clampi(hp - amt, 0, max_hp)
	print("hp now : " + str(hp) + " / " + str(max_hp))
	print("hp percent : " + str(float(hp) / max_hp))
	
	hp_changed.emit( float(hp) / max_hp )
	
	if hp <= 0:
		died.emit()

func _on_hurtbox_got_hit(source:Hitbox):
	hurt(source.damage)
	pass # Replace with function body.
