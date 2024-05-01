extends CanvasLayer

var frame:int = 0
var total_frames:int = 23
var loaded:bool = false

var materials = []

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	get_particle_folder()
	load_particles()

func get_particle_folder() -> void:
	var path = "res://PARTICLES/particles"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		print(file_name)
		if file_name == "":
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			materials.append(load(path + "/" + file_name))
	dir.list_dir_end()

func load_particles() -> void:
	print("preloading particles")
	if !loaded:
		frame = 0
		set_physics_process(true)
		for material in materials:
			var particles_instance:GPUParticles2D = GPUParticles2D.new() as GPUParticles2D
			particles_instance.process_material = material
			particles_instance.position = Vector2(123, 123)
			particles_instance.one_shot = true
			particles_instance.modulate = Color(1, 1, 1, 0)
			particles_instance.emitting = true
			self.add_child(particles_instance)

func _physics_process(delta):
	var frame_ratio = float(frame) / total_frames
	frame += 1
	if frame > total_frames:
		print("done preloading")
		set_physics_process(false)

func get_frame() -> int:
	return frame
