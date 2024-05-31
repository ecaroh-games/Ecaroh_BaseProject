@icon("res://ICONS/glass-ball.png")
class_name StateMachine extends Node

@export var initial_state : State

var prev_state : State
var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.call_deferred("Enter")
		current_state = initial_state

func _process(delta) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func _input(event):
	current_state.input_event(event)

func on_child_transition(state, new_state_name) -> void:
	#print("PLAYER transitioning... " + str(state.get_name()) + " >> " + str(new_state_name))
	if state != current_state:
		print("return error")
		print(str(current_state))
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("invalid new state (" + str(new_state_name.to_lower()) + ")")
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.prev_state = current_state.get_name()
	new_state.prev_state_REF = current_state
	current_state = new_state
	new_state.Enter()
	
	
	#player.set_active_state(current_state)

func _on_anim_animation_finished() -> void:
	current_state.on_anim_finished()

func _on_anim_frame_changed() -> void:
	current_state.on_frame_change()

func switch_state(new_state_name:String) -> void:
	on_child_transition(current_state, new_state_name)
