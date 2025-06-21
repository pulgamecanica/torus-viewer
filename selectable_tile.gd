extends Node3D

var coords := Vector2i.ZERO
var selected := false

@onready var mesh_instance := $MeshInstance3D

func set_selected(value: bool):
	selected = value
	var mat = mesh_instance.get_active_material(0) as StandardMaterial3D
	if not mat:
		mat = StandardMaterial3D.new()
		mesh_instance.set_surface_override_material(0, mat)
	mat.albedo_color = Color.RED if selected else Color.WHITE

@onready var label = $MeshInstance3D/Label3D

func set_coords(coords: Vector2i):
	self.coords = coords
	#label.text = "(%d, %d)" % [coords.x, coords.y]
