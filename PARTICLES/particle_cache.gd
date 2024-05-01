extends CanvasLayer

var loading:bool = false

var material_paths = []
var materials = []
var current_material_num := 0
#var temp_texture = preload("res://ASSETS/ICONS/allied-star.png")
#var temp_material = preload("res://PARTICLES/new_canvas_item_material.tres")

var asyncLoadingPath:String

#@onready var load_bar_scene = preload("res://PARTICLES/loading_bar.tscn")
@export var load_bar:ProgressBar
var progress = []

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	get_particle_folder()
	await get_tree().create_timer(1.123).timeout
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
	#particles_instance.texture = temp_texture
	#particles_instance.material = temp_material
	particles_instance.position = Vector2(123, 123)
	particles_instance.one_shot = true
	
	# i find that setting this to 0 will not trigger the shader to compile...
	# recommend hiding the GPU particles behind a canvas layer
	#particles_instance.modulate = Color(1, 1, 1, 0)
	particles_instance.emitting = true
	await get_tree().create_timer(0.123).timeout
	self.add_child(particles_instance)
			

func _physics_process(delta):
	if loading:
		ResourceLoader.load_threaded_get_status(asyncLoadingPath, progress)
		if load_bar != null:
			var big_chunk = float(current_material_num+1) / (material_paths.size())
			var small_chunk = 0#float(progress[0]) / material_paths.size()
			load_bar.value = (big_chunk + small_chunk) * 100

		if (ResourceLoader.load_threaded_get_status(asyncLoadingPath) == ResourceLoader.THREAD_LOAD_LOADED):
			
			#instantiates the particle  -- this is when the lag spike occurs
			instantiate_next_particle()
			
			# small pause for load bar readability
			await get_tree().create_timer(0.123).timeout
			
			if current_material_num >= material_paths.size() - 1:
				print("done loading " + str( material_paths.size() ))
				loading = false
				load_bar.set_message("done")
				await get_tree().create_timer(1.123).timeout
				set_physics_process(false)
				load_bar.queue_free()
			else:
				current_material_num += 1
				load_next_particle()
