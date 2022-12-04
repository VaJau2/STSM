extends Node

#--------------------------------
# Отвечает за состояние игрока
#--------------------------------

class_name PlayerStates


var moving_state = moving_states.walking
enum moving_states {walking, running, crouching, stunned}

signal changed


func set_state(new_state: int):
	if moving_state == new_state: return
	moving_state = new_state
	emit_signal("changed")


func clean() -> void:
	set_state(moving_states.walking)


func set_stunned(stun: bool) -> void:
	set_state(moving_states.stunned if stun else moving_states.walking)


func toggle_crouching() -> void:
	if moving_state == moving_states.crouching:
		clean()
	else:
		set_state(moving_states.crouching)


func set_running(run: bool) -> void:
	if run:
		set_state(moving_states.running)
		return
	
	if moving_state == moving_states.crouching: return
	clean()


func is_running() -> bool:
	return moving_state == moving_states.running


func is_crouching() -> bool:
	return moving_state == moving_states.crouching


func may_move() -> bool:
	return moving_state != moving_states.stunned
