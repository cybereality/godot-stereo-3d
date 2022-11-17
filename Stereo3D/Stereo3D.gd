# [Godot Stereo 3D]
# created by Andres Hernandez
tool
extends Spatial

# stereo strength controls the distance between the eyes
export(float, 0.0, 100.0) var stereo_strength = 50.0 setget change_strength
# parallax depth controls the zero plane (distance on z axis where the eyes focus)
export(float, 0.0, 100.0) var parallax_depth = 50.0 setget change_parallax_depth
# parallax offset adjusts the overlap to be more comfortable or for more depth
export(float, 0.0, 100.0) var parallax_offset = 50.0 setget change_parallax_offset
# z near should match your camera node
export var z_near = 0.1 setget change_near
# z far should match your camera node
export var z_far = 100.0 setget change_far
# enables stereo 3D in game or editor or both, must be controlled here
export(int, FLAGS, "Game", "Editor") var enable = 3 setget change_enable
# material for screen overlap shader
var shader_material

# sets up the parameters for the stereo 3D
func _ready():
	#warning-ignore:RETURN_VALUE_DISCARDED
	self.connect("visibility_changed", self, "on_visible_change")
	change_strength(stereo_strength)
	change_parallax_depth(parallax_depth)
	change_parallax_offset(parallax_offset)
	change_near(z_near)
	change_far(z_far)
	change_enable(enable)
	
# gets the main overlay shader (needs to be dynamic to work in editor)
func get_shader():
	if not shader_material:
		shader_material = get_node("Overlay").get_surface_material(0)
	return shader_material
	
# changes the eye separation
func change_strength(val):
	stereo_strength = val
	var eye_separation = stereo_strength / 250000.0
	get_shader().set_shader_param("stereo_strength", eye_separation)

# changes the zero parallax plane
func change_parallax_depth(val):
	parallax_depth = val
	var zero_plane = parallax_depth / 100.0;
	get_shader().set_shader_param("parallax_depth", zero_plane)
	
# changes the offset
func change_parallax_offset(val):
	parallax_offset = val
	var offset_amount = (100.0 - parallax_offset) / 5000.0;
	get_shader().set_shader_param("parallax_offset", offset_amount)
	
# changes if stereo 3D is enabled in game or editor
func change_enable(val):
	enable = val
	if Engine.editor_hint:
		visible = enable & 2
	else:
		visible = enable & 1

# changes the z near
func change_near(val):
	z_near = val
	get_shader().set_shader_param("z_near", z_near)
	
# changes the z far
func change_far(val):
	z_far = val
	get_shader().set_shader_param("z_far", z_far)

# enables the stereo 3D when overlay is visible
func on_visible_change():
	change_enable(enable)

