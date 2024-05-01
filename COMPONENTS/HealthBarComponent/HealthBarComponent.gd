extends Node2D

@export var myHeart:PackedScene
@export var spacing := 23.0

var hp_bar = []

var max_hp:int


func _on_health_component_hp_changed(ratio):
	var filled = round(ratio * max_hp)
	for hp:Node2D in hp_bar:
		if hp.get_index() < filled:
			hp.modulate = Color.WHITE
		else:
			hp.modulate = Color.WHITE * 0.23
	pass # Replace with function body.


func _on_health_component_hp_set(max_hp):
	create_bar(max_hp)
	pass # Replace with function body.


func create_bar(max:int):
	max_hp = max
	
	for old in hp_bar:
		old.queue_free()
		
	hp_bar = []
	for i in max:
		var hp = myHeart.instantiate()
		add_child(hp)	
		hp.position.x = spacing * i
		
		hp_bar.append(hp)
	
	position.y = - 23
	position.x = - 0.5 * (spacing * max)
