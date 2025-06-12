extends ColorRect
class_name Background

@export var follow_camera: bool = true
@export var update_continuously: bool = true
@export var performance_mode: bool = false  ## Reduces samples when true

var grid_material: ShaderMaterial
var main_camera: Camera2D

func _ready():
	# Set up as background layer
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	z_index = -1000
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	grid_material = material
	
	# Find the main camera
	if follow_camera:
		find_main_camera()
	
	# Set up initial shader parameters
	setup_shader_params()

func find_main_camera():
	# Try to find Camera2D in the scene
	var cameras = get_tree().get_nodes_in_group("camera")
	if cameras.size() > 0:
		main_camera = cameras[0]
	else:
		# Fallback: search for any Camera2D
		main_camera = find_camera_recursive(get_tree().root)

func find_camera_recursive(node: Node) -> Camera2D:
	if node is Camera2D:
		return node
	for child in node.get_children():
		var result = find_camera_recursive(child)
		if result:
			return result
	return null

func setup_shader_params():
	if not grid_material:
		return
	
	# Set performance-based defaults
	if performance_mode:
		grid_material.set_shader_parameter("stochastic_samples", 4)
		grid_material.set_shader_parameter("enable_fade", true)
	else:
		grid_material.set_shader_parameter("stochastic_samples", 8)
		grid_material.set_shader_parameter("enable_fade", false)
	
	# Set other defaults
	grid_material.set_shader_parameter("cell_size", 32.0)
	grid_material.set_shader_parameter("dot_size", 0.3)
	grid_material.set_shader_parameter("anti_aliasing_factor", 0.02)

func _process(_delta):
	if not update_continuously or not follow_camera or not main_camera or not grid_material:
		return
	
	# Update camera offset for infinite scrolling
	var camera_pos = main_camera.global_position
	grid_material.set_shader_parameter("camera_offset", camera_pos)
	
	# Update camera zoom for proper grid scaling
	var camera_zoom = 1.0
	if main_camera.zoom.x > 0:
		camera_zoom = 1.0 / main_camera.zoom.x  # Convert zoom to scale factor
	grid_material.set_shader_parameter("camera_zoom", camera_zoom)

# Public methods to control the grid
func set_grid_size(size: float):
	if grid_material:
		grid_material.set_shader_parameter("cell_size", size)

func set_dot_size(size: float):
	if grid_material:
		grid_material.set_shader_parameter("dot_size", clamp(size, 0.05, 0.8))

func set_grid_colors(bg_color: Color, dot_color: Color):
	if grid_material:
		grid_material.set_shader_parameter("background_color", bg_color)
		grid_material.set_shader_parameter("dot_color", dot_color)

func set_performance_mode(enabled: bool):
	performance_mode = enabled
	if grid_material:
		if enabled:
			grid_material.set_shader_parameter("stochastic_samples", 4)
			grid_material.set_shader_parameter("enable_fade", true)
		else:
			grid_material.set_shader_parameter("stochastic_samples", 8)
			grid_material.set_shader_parameter("enable_fade", false)

func set_zoom_scaling(enabled: bool, min_size: float = 0.5):
	if grid_material:
		grid_material.set_shader_parameter("enable_density_fade", enabled)
		grid_material.set_shader_parameter("min_dot_size", min_size)

func toggle_visibility():
	visible = not visible

# Get current camera zoom level
func get_camera_zoom() -> float:
	if main_camera and main_camera.zoom.x > 0:
		return 1.0 / main_camera.zoom.x
	return 1.0
