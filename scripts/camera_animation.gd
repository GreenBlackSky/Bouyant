extends AnimationPlayer


const total_levels = 4
export(float) var camera_rotation_speed = 1
export(float) var camera_zoom_speed = 25

export(float) var camera_rotation_max = PI/4
export(float) var camera_rotation_min = 0
export(float) var camera_zoom_max = 13
export(float) var camera_zoom_min = 5

var previous_mouse_position = Vector2()
var previous_level = 0
var current_level = 0
var previous_piece_n
var pieces_map


func _ready():
	pieces_map = [
		[], # 0
		[
			$pieces/Level_1_1,
			$pieces/Level_1_2,
			$pieces/Level_1_3,
			$pieces/Level_1_4,
			$pieces/Level_1_5,
			$pieces/Level_1_6,
			$pieces/Level_1_7,
			$pieces/Level_1_8
		],[
			$pieces/Level_2_1,
			$pieces/Level_2_2,
			$pieces/Level_2_3,
			$pieces/Level_2_4,
			$pieces/Level_2_5,
			$pieces/Level_2_6,
			$pieces/Level_2_7,
			$pieces/Level_2_8
		],[
			$pieces/Level_3_1,
			$pieces/Level_3_2,
			$pieces/Level_3_3,
			$pieces/Level_3_4,
			$pieces/Level_3_5,
			$pieces/Level_3_6,
			$pieces/Level_3_7,
			$pieces/Level_3_8
		],
	]
	previous_piece_n = int(($camera_pivot.rotation.y/PI + 1) * 4)


func swithc_group_visibility(old_y, old_x, new_y, new_x):
	for i in range(3):
		switch_visibility(old_y, (old_x + i)%8, true)
		switch_visibility(new_y, (new_x + i)%8, false)


func switch_visibility(y, x, visibility):
	if len(pieces_map) > y and len(pieces_map[y]) > x:
		pieces_map[y][x].visible = visibility


func _update_invisible_peices():
	var current_piece_n = int(($camera_pivot.rotation.y/PI + 1) * 4)
	if current_level != previous_level:
		swithc_group_visibility(previous_level, current_piece_n, current_level, current_piece_n)
		previous_level = current_level
	if previous_piece_n != current_piece_n:
		swithc_group_visibility(current_level, previous_piece_n, current_level, current_piece_n)
		previous_piece_n = current_piece_n


func _process(delta):
	if Input.is_action_just_pressed("move_camera_up") and current_level > 0:
		play("move_camera_up")
	if Input.is_action_just_pressed("move_camera_down") and current_level < total_levels:
		play("move_camera_down")
	if Input.is_action_pressed("camera_control"):
		var mouse_position = get_viewport().get_mouse_position()
		if previous_mouse_position and mouse_position != previous_mouse_position:
			var diff = (previous_mouse_position - mouse_position)*camera_rotation_speed*delta
			$camera_pivot.rotate(Vector3(0, 1, 0), diff.x)
			var camera_base = $camera_pivot/camera_base
			if (
				(diff.y > 0 and camera_base.rotation.x < -camera_rotation_min) or
				(diff.y < 0 and camera_base.rotation.x > -camera_rotation_max)
			):
				camera_base.rotate(Vector3(1, 0, 0), diff.y)
		previous_mouse_position = mouse_position
	else:
		previous_mouse_position = Vector2()
	if Input.is_action_just_released("camera_zoom_in"):
		var camera = $camera_pivot/camera_base/camera
		if camera.transform.origin.z > camera_zoom_min:
			camera.translate(Vector3(0, 0, -camera_zoom_speed*delta))
	if Input.is_action_just_released("camera_zoom_out"):
		var camera = $camera_pivot/camera_base/camera
		if camera.transform.origin.z < camera_zoom_max:
			camera.translate(Vector3(0, 0, camera_zoom_speed*delta))
	_update_invisible_peices()


func _animation_finished(anim_name):
	previous_level = current_level
	if anim_name == "move_camera_up":
		$camera_pivot.translate(Vector3(0, 2, 0))
		$camera_pivot/camera_base.translate(Vector3(0, -2, 0))
		current_level -= 1
	if anim_name == "move_camera_down":
		$camera_pivot/camera_base.translate(Vector3(0, 2, 0))
		$camera_pivot.translate(Vector3(0, -2, 0))
		current_level += 1
