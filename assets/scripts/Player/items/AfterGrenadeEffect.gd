extends ColorRect

signal done


func show():
	visible = true
	$anim.current_animation = "show"
	$audi.play()
	yield(get_tree().create_timer(3.8), "timeout")
	visible = false
	emit_signal("done")
