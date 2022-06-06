extends AnimationPlayer


const total_levels = 4
export(float) var camera_rotation_speed = 1
export(float) var camera_zoom_speed = 25

export(float) var camera_rotation_max = PI/4
export(float) var camera_rotation_min = 0
export(float) var camera_zoom_max = 13
export(float) var camera_zoom_min = 5

var current_level = 0
var previous_mouse_position = Vector2()


func _process(delta):
	if Input.is_action_just_pressed("move_camera_up") and current_level > 0:
		play("move_camera_up")
	if Input.is_action_just_pressed("move_camera_down") and current_level < total_levels:
		play("move_camera_down")
	if Input.is_action_pressed("camera_control"):
		var mouse_position = get_viewport().get_mouse_position()
		if previous_mouse_position and mouse_position != previous_mouse_position:
			var diff = (previous_mouse_position - mouse_position)*camera_rotation_speed*delta
			$"camera_pivot".rotate(Vector3(0, 1, 0), diff.x)
			var camera_base = $"camera_pivot/camera_base"
			if (
				(diff.y > 0 and camera_base.rotation.x < -camera_rotation_min) or
				(diff.y < 0 and camera_base.rotation.x > -camera_rotation_max)
			):
				camera_base.rotate(Vector3(1, 0, 0), diff.y)
		previous_mouse_position = mouse_position
	else:
		previous_mouse_position = Vector2()
	if Input.is_action_just_released("camera_zoom_in"):
		var camera = $"camera_pivot/camera_base/camera"
		if camera.transform.origin.z > camera_zoom_min:
			camera.translate(Vector3(0, 0, -camera_zoom_speed*delta))
	if Input.is_action_just_released("camera_zoom_out"):
		var camera = $"camera_pivot/camera_base/camera"
		if camera.transform.origin.z < camera_zoom_max:
			camera.translate(Vector3(0, 0, camera_zoom_speed*delta))


func _animation_finished(anim_name):
	if anim_name == "move_camera_up":
		$"camera_pivot".translate(Vector3(0, 2, 0))
		$"camera_pivot/camera_base".translate(Vector3(0, -2, 0))
		current_level -= 1
	if anim_name == "move_camera_down":
		$"camera_pivot/camera_base".translate(Vector3(0, 2, 0))
		$"camera_pivot".translate(Vector3(0, -2, 0))
		current_level += 1
