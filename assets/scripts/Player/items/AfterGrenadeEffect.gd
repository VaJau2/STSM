extends ColorRect

signal done


func show():
	visible = true
	$anim.current_animation = "show"
	$audi.play()


func _on_anim_animation_finished(anim_name):
	if visible && anim_name == "show":
		visible = false
		emit_signal("done")
