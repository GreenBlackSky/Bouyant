extends AnimationPlayer


var current_level = 0
const total_levels = 4
var camera_speed = 1
var previous_mouse_position = Vector2()


func _process(delta):
	if Input.is_action_just_pressed("move_camera_up") and current_level > 0:
		play("move_camera_up")
	if Input.is_action_just_pressed("move_camera_down") and current_level < total_levels:
		play("move_camera_down")
	if Input.is_action_pressed("camera_control"):
		var mouse_position = get_viewport().get_mouse_position()
		if previous_mouse_position and mouse_position != previous_mouse_position:
			var diff = (previous_mouse_position - mouse_position)*camera_speed*delta
			get_node("camera_pivot").rotate(Vector3(0, 1, 0), diff.x)
			var camera_base = get_node("camera_pivot/camera_base")
			if (
				(diff.y > 0 and camera_base.rotation.x < 0) or
				(diff.y < 0 and camera_base.rotation.x > -PI/4)
			):
				camera_base.rotate(Vector3(1, 0, 0), diff.y)
		previous_mouse_position = mouse_position
	else:
		previous_mouse_position = Vector2()


func _animation_finished(anim_name):
	if anim_name == "move_camera_up":
		get_node("camera_pivot").translate(Vector3(0, 2, 0))
		get_node("camera_pivot/camera_base").translate(Vector3(0, -2, 0))
		current_level -= 1
	if anim_name == "move_camera_down":
		get_node("camera_pivot/camera_base").translate(Vector3(0, 2, 0))
		get_node("camera_pivot").translate(Vector3(0, -2, 0))
		current_level += 1
