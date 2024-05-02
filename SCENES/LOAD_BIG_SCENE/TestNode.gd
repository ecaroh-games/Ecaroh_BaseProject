extends AnimatedSprite2D

var time := 0.0
@onready var start_pos := position

@onready var Anim = self

#ECHO
@export var echo:EchoResource
signal emit_echo()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * 2.3
	position = start_pos + Vector2(cos(time) * 200, sin(time*2)*200)
	emit_echo.emit(self, echo)
	pass
