extends Camera3D

var yaw := 0.0
var pitch := 0.0
var distance := 15.0

func _unhandled_input(event):
	if event is InputEventMouseMotion and (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		yaw -= event.relative.x * 0.01
		pitch = clamp(pitch - event.relative.y * 0.01, -PI * 0.49, PI * 0.49)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = max(2.0, distance - 1.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = min(100.0, distance + 1.0)

func _process(delta):
	var x = distance * cos(pitch) * sin(yaw)
	var y = distance * sin(pitch)
	var z = distance * cos(pitch) * cos(yaw)
	global_transform.origin = Vector3(x, y, z)
	look_at(Vector3.ZERO, Vector3.UP)
