# [Godot Stereo 3D]
# created by Andres Hernandez
tool
extends Spatial

# separation controls the distance between the eyes
export(float, 0.0, 100.0) var separation = 50.0 setget change_separation
# convergence controls the focus plane (distance on z axis where the eyes focus)
export(float, 0.0, 100.0) var convergence = 50.0 setget change_convergence
# pop out adjusts the overlap to be more comfortable or for more depth
export(float, 0.0, 100.0) var pop_out = 50.0 setget change_pop_out
# z near should match your camera node
export var z_near = 0.05 setget change_near
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
	change_separation(separation)
	change_convergence(convergence)
	change_pop_out(pop_out)
	change_near(z_near)
	change_far(z_far)
	change_enable(enable)
	
# gets the main overlay shader (needs to be dynamic to work in editor)
func get_shader():
	if not shader_material:
		shader_material = get_node("Overlay").get_surface_material(0)
	return shader_material
	
# changes the separation
func change_separation(val):
	separation = val
	var eye_separation = separation / 40000.0
	get_shader().set_shader_param("eye_separation", eye_separation)

# changes the convergence
func change_convergence(val):
	convergence = val
	var convergence_plane = convergence / 1000.0;
	get_shader().set_shader_param("convergence_plane", convergence_plane)
	
# changes the pop out
func change_pop_out(val):
	pop_out = val
	var parallax_offset = (100.0 - pop_out) / 10000.0;
	get_shader().set_shader_param("parallax_offset", parallax_offset)
	
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

