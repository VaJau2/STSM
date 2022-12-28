extends ColorRect

#--------------------------------
# Эффект затемнения экрана
# Отвечает за плавный выход из уровня
#--------------------------------


const SPEED = 1

var animating_exit: bool = false
var next_scene: String = ""


func animate_exit(new_scene: String) -> void:
	animating_exit = true
	next_scene = new_scene
	visible = true
	set_process(true)


func cancel_exit() -> void:
	if is_processing():
		color.a = 0
		set_process(false)


func _process(delta: float) -> void:
	var temp_delta = delta if animating_exit else -delta
	temp_delta *= SPEED
	var is_working = color.a < 1 if animating_exit else color.a > 0
	
	if is_working:
		color.a += temp_delta
	else:
		if animating_exit:
			G.goto_scene(next_scene)
		else:
			visible = false
			set_process(false)
