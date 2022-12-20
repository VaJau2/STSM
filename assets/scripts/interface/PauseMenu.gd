extends ColorRect


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = visible
