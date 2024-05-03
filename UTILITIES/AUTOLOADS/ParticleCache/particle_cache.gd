extends CanvasLayer

var loading:bool = false

var material_paths = []
var materials = []
var current_material_num := 0

var asyncLoadingPath:String

var progress = []

var loading_queue = []
var current_queue_size := 0

func _ready() -> void:
	layer = -123
	process_mode = PROCESS_MODE_ALWAYS
	get_particle_folder()
	print("particle folder found: " + str(material_paths.size()) + " files total")

func get_particle_folder() -> void:
	var path = "res://PARTICLES/particles"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			material_paths.append(path + "/" + file_name)
	dir.list_dir_end()
	
func queue_particles(num:int):
	for i in range(num):
		queue_next_particle()
	print("current queue" + str(loading_queue))
	current_queue_size = loading_queue.size()
	load_next_particle()
	
func queue_next_particle():
	if current_material_num < material_paths.size():
		var next_material =  material_paths[current_material_num]
		print("queued: "+ str(next_material))
		loading_queue.append(next_material)
		current_material_num += 1
	else:
		print("maxed out queue")
		return

func load_next_particle():
	if loading_queue.size() > 0:
		loading = true
		set_physics_process(true)
		
		PreloadBar.set_visible(true)
		PreloadBar.set_message("loading particles")
		
		asyncLoadingPath = loading_queue.pop_front()
		if '.tres.remap' in asyncLoadingPath: # <---- NEW
			print("TRIMMING .remap")
			asyncLoadingPath = asyncLoadingPath.trim_suffix('.remap') # <---- NEW
		print(". . .")
		print("loading material - " + str(asyncLoadingPath))
		ResourceLoader.load_threaded_request(asyncLoadingPath)
	else:
		print("no more particles to load")
		return

func instantiate_next_particle() -> void:
	print("intantiating gpu particle - " + str(asyncLoadingPath))
	var material = ResourceLoader.load_threaded_get(asyncLoadingPath)
	var particles_instance:GPUParticles2D = GPUParticles2D.new() as GPUParticles2D
	particles_instance.process_material = material
	particles_instance.position = Vector2(123, 123)
	particles_instance.one_shot = true
	
	# i find that setting alpha to 0 will not trigger the shader to compile...
	# recommend hiding the GPU particles behind a canvas layer
	#particles_instance.modulate = Color(1, 1, 1, 0)
	
	particles_instance.emitting = true
	await get_tree().create_timer(0.123).timeout
	self.add_child(particles_instance)
	
			

func _physics_process(_delta):
	if loading:
		ResourceLoader.load_threaded_get_status(asyncLoadingPath, progress)
		
		var load_ratio = float(current_material_num - loading_queue.size() ) / (material_paths.size())
		if current_queue_size > 0:
			var load_current_ratio = 1.0 - (float(loading_queue.size()) / current_queue_size)
			PreloadBar.update_current_progress( load_current_ratio * 100 )
			print(load_current_ratio)
		PreloadBar.update_global_progress(load_ratio * 100)
		

		if (ResourceLoader.load_threaded_get_status(asyncLoadingPath) == ResourceLoader.THREAD_LOAD_LOADED and loading):
			
			#instantiates the particle  -- this is when the lag spike occurs
			instantiate_next_particle()
			
			# small pause for load bar readability
			await get_tree().create_timer(0.123).timeout
			
			if loading_queue.size() == 0:
				print("done loading queue " + str( current_material_num ) + "/" + str(material_paths.size()) )
				loading = false
				PreloadBar.set_message("done")
				await get_tree().create_timer(1.123).timeout
				set_physics_process(false)
				PreloadBar.set_visible(false)
			else:
				load_next_particle()
