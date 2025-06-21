extends Node3D

const MAJOR_RADIUS := 6.0
const MINOR_RADIUS := 2.0
const TILE_SEGMENTS := 12
const TILE_RINGS := 8

@onready var torus_container = $TorusContainer

# Scroll in radians (not in tile units)
var scroll_u := 0.0
var scroll_v := 0.0
var scroll_speed := 1.5  # radians per second

var tile_grid := []
var selected_tile: Node3D = null

func _ready():
	generate_torus()

func _process(delta):
	var moved := false

	# Continuous smooth movement
	if Input.is_action_pressed("move_left"):
		scroll_u += scroll_speed * delta
		moved = true
	if Input.is_action_pressed("move_right"):
		scroll_u -= scroll_speed * delta
		moved = true
	if Input.is_action_pressed("move_up"):
		scroll_v += scroll_speed * delta
		moved = true
	if Input.is_action_pressed("move_down"):
		scroll_v -= scroll_speed * delta
		moved = true

	if moved:
		update_tiles()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select_tile_at_mouse()

func generate_torus():
	var tile_scene = preload("res://selectable_tile.tscn")
	tile_grid.clear()

	for i in TILE_SEGMENTS:
		tile_grid.append([])
		for j in TILE_RINGS:
			var tile = tile_scene.instantiate()
			torus_container.add_child(tile)
			tile_grid[i].append(tile)

	update_tiles()

func update_tiles():
	for i in TILE_SEGMENTS:
		for j in TILE_RINGS:
			var tile = tile_grid[i][j]
			var pos = torus_position(i, j)
			tile.global_transform.origin = pos

func torus_position(i: int, j: int) -> Vector3:
	var u = float(i) / TILE_SEGMENTS * TAU + scroll_u
	var v = float(j) / TILE_RINGS * TAU + scroll_v

	var x = (MAJOR_RADIUS + MINOR_RADIUS * cos(v)) * cos(u)
	var y = (MAJOR_RADIUS + MINOR_RADIUS * cos(v)) * sin(u)
	var z = MINOR_RADIUS * sin(v)
	return Vector3(x, y, z)

func select_tile_at_mouse():
	var viewport = get_viewport()
	var camera = $Camera3D
	var mouse_pos = viewport.get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 100.0

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1

	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result:
		var clicked = result["collider"]
		if clicked and clicked.has_method("set_selected"):
			if selected_tile and selected_tile != clicked:
				selected_tile.set_selected(false)
			clicked.set_selected(true)
			selected_tile = clicked
