extends ColorRect

const SPEED = 1


func _process(delta: float) -> void:
	if color.a > 0:
		color.a -= delta * SPEED
	else:
		visible = false
		set_process(false)
