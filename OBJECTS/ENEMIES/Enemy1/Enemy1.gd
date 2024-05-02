@icon("res://ASSETS/ICONS/bat.png")
class_name Enemy1 extends Enemy


func _on_health_component_died():
	print("died")
	queue_free()
	pass # Replace with function body.
