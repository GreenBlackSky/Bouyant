extends AnimationPlayer


var current_level = 0
const total_levels = 4


func _process(delta):
	if Input.is_action_just_pressed("move_camera_up") and current_level > 0:
		play("move_camera_up")
	if Input.is_action_just_pressed("move_camera_down") and current_level < total_levels:
		play("move_camera_down")


func _animation_finished(anim_name):
	if anim_name == "move_camera_up":
		get_node("camera_pivot").translate(Vector3(0, 2, 0))
		get_node("camera_pivot/camera_base").translate(Vector3(0, -2, 0))
		current_level -= 1
	if anim_name == "move_camera_down":
		get_node("camera_pivot/camera_base").translate(Vector3(0, 2, 0))
		get_node("camera_pivot").translate(Vector3(0, -2, 0))
		current_level += 1
