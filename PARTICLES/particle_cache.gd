extends CanvasLayer

var frame:int = 0
var total_frames:int = 23
var loading:bool = false

var material_paths = []
var materials = []
var current_material_num := 0
var temp_texture = preload("res://ASSETS/ICONS/allied-star.png")
var temp_material = preload("res://PARTICLES/new_canvas_item_material.tres")

var asyncLoadingPath:String

#@onready var load_bar_scene = preload("res://PARTICLES/loading_bar.tscn")
@export var load_bar:ProgressBar
var progress = []

func _ready() -> void:
	#load_bar = load_bar_scene.instantiate()
	#load_bar.position = Vector2(123, 123)
	#add_child(load_bar)
	process_mode = PROCESS_MODE_ALWAYS
	get_particle_folder()
	load_next_particle()

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
			material_paths.append(path + "/" + file_name)
	dir.list_dir_end()

func load_next_particle():
	loading = true
	set_physics_process(true)
	asyncLoadingPath = material_paths[current_material_num]
	if '.tres.remap' in asyncLoadingPath: # <---- NEW
		print("TRIMMING .remap")
		asyncLoadingPath = asyncLoadingPath.trim_suffix('.remap') # <---- NEW
	print(". . .")
	print("loading material - " + str(asyncLoadingPath))
	ResourceLoader.load_threaded_request(asyncLoadingPath)

func instantiate_next_particle() -> void:
	print("intantiating gpu particle - " + str(asyncLoadingPath))
	var material = ResourceLoader.load_threaded_get(asyncLoadingPath)
	var particles_instance:GPUParticles2D = GPUParticles2D.new() as GPUParticles2D
	particles_instance.process_material = material
	particles_instance.texture = temp_texture
	particles_instance.material = temp_material
	particles_instance.position = Vector2(123, 123)
	particles_instance.one_shot = true
	particles_instance.modulate = Color(1, 1, 1, 1)
	particles_instance.emitting = true
	self.add_child(particles_instance)
			

func _physics_process(delta):
	if loading:
		ResourceLoader.load_threaded_get_status(asyncLoadingPath, progress)
		var big_chunk = float(current_material_num) / (material_paths.size() -1)
		var small_chunk = (float(progress[0]) / (material_paths.size() -1)) 
		load_bar.value = (big_chunk + small_chunk) * 100
		#print(ResourceLoader.load_threaded_get_status(asyncLoadingPath))
		if (ResourceLoader.load_threaded_get_status(asyncLoadingPath) == ResourceLoader.THREAD_LOAD_LOADED):
			instantiate_next_particle()
			if current_material_num >= material_paths.size()-1:
				print("done loading " + str(current_material_num))
				loading = false
				set_physics_process(false)
				await get_tree().create_timer(0.23).timeout
				load_bar.queue_free()
			else:
				current_material_num += 1
				await get_tree().create_timer(0.1).timeout
				load_next_particle()
				
	#var frame_ratio = float(frame) / total_frames
	#frame += 1
	#if frame > total_frames:
		#print("done preloading")
		#set_physics_process(false)

func get_frame() -> int:
	return frame
