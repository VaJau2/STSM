extends Node2D


func _process(_delta) -> void:
	if !visible: return
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	rotation_degrees = clamp(rotation_degrees, -60, 60)
