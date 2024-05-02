extends CanvasLayer

#@export var overlay:TextureRect
@export var shader1:ColorRect
#@export var shader2:ColorRect
#@export var shader3_godrays:ColorRect
#@export var sand:GroundFloor
@export var cam:Camera2D
#
#@export var contrastMin = 0.7
#@export var contrastMax = 4.0
#@export var shiftMin = -0.38
#@export var shiftMax = 0.23
#
#@export var grad1:Color
#@export var grad2:Color
#@export var grad:GradientTexture1D



# Called when the node enters the scene tree for the first time.
func _ready():
	shader1.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var ratio = player.dget_depth_ratio()
	
	#sand.modulate = lerp(sand.surface_color, sand.depth_color, player.get_depth_ratio())
	#
	#overlay.modulate.a = lerp(0.0, 0.77, player.get_depth_ratio(-3000))
	#overlay.texture.fill_from.x = player.get_global_transform_with_canvas().get_origin().x / Screen.width()
	#
	#var col = lerp(grad1, grad2, ratio)
	#grad.gradient.colors[2] = col
	
	#shader1.get_material().set_shader_parameter("palette", grad)
	#shader1.get_material().set_shader_parameter("contrast", lerp(contrastMin, contrastMax, ratio))
	#shader1.get_material().set_shader_parameter("shift", lerp(shiftMax, shiftMin, ratio))
	#
	if cam:
		shader1.get_material().set_shader_parameter("player_position", cam.position / 2.3)
	#
	#shader3_godrays.get_material().set_shader_parameter("cutoff", lerp(-0.69, -0.23, ratio))
	#shader3_godrays.get_material().set_shader_parameter("falloff", lerp(0.69, 1.23, ratio))
	#shader3_godrays.get_material().set_shader_parameter("ray1_density", lerp(2.3, 3.23, ratio))
	pass
