extends Node

#--------------------------------
# Отвечает за состояние игрока
#--------------------------------


class_name PlayerStates


var moving_state = moving_states.walking
enum moving_states {none, walking, running, crouching, stunned}


func set_stunned(stun: bool) -> void:
	if stun:
		moving_state = moving_states.stunned
	else:
		moving_state = moving_states.none


func toggle_crouching() -> void:
	if moving_state == moving_states.crouching:
		moving_state = moving_states.walking
	else:
		moving_state = moving_states.crouching


func set_running(run: bool) -> void:
	if run:
		moving_state = moving_states.running
		return
	
	if moving_state == moving_states.crouching:
		return
		
	moving_state = moving_states.walking


func is_running() -> bool:
	return moving_state == moving_states.running


func is_crouching() -> bool:
	return moving_state == moving_states.crouching


func may_move() -> bool:
	return moving_state != moving_states.stunned
