extends Node2D

#--------------------------------
# Класс области видимости
# Определяет бегающего, идущего или крадущегося игрока в зависимости от расстояния
#--------------------------------

onready var parent = get_parent()
onready var ray = get_node_or_null("../seekRay")

var see_player: bool
var victim: Character
var tied_allies: Array
var victim_position: Vector2 setget ,get_victim_position

enum checks {none, running, walking, any}
var check = checks.none


func get_victim_position() -> Vector2:
	if victim == null: return Vector2.ZERO
	return victim.global_position


func set_see_player(see: bool):
	see_player = see
	var new_state = parent.states.attack if see_player else parent.states.search
	parent.set_state(new_state)


func set_check(new_check: int):
	check = new_check
	if check == checks.none:
		ray.enabled = false
	else:
		ray.enabled = true


func raycast_see_victim(check_victim: Character) -> bool:
	if ray == null: return true
	var dir = check_victim.global_position - global_position
	ray.scale.x = ray.scale.y * (-1.0 if parent.flip_x else 1.0)
	ray.cast_to = dir
	var result = ray.is_colliding() && ray.get_collider() == check_victim
	return result


func _process(_delta) -> void:
	if check == checks.none: return
	var temp_see = true
	if !raycast_see_victim(victim):
		temp_see = false
	match check:
		checks.running:
			if !victim.is_running():
				temp_see = false
		checks.walking:
			if victim.is_crouching():
				temp_see = false
	if temp_see: set_see_player(true)
	elif see_player: set_see_player(false)


func _on_body_entered(body, condition):
	if condition == "close" && body is Guard:
		if body.is_tied:
			tied_allies.append(body)
	
	if !see_player && body.name == "flashlight":
		victim = body.get_node("../../")
		set_see_player(true)
		
	if body.name != "Player": return
	match condition:
		"running":
			victim = body
			set_check(checks.running)
		"walking":
			set_check(checks.walking)
		"close": 
			set_check(checks.any)


func _on_body_exited(body, condition):
	if body.name != "Player": return
	match condition:
		"close":
			set_check(checks.walking)
		"walking":
			set_check(checks.running)
		"running":
			set_check(checks.none)
			set_see_player(false)
			victim = null
