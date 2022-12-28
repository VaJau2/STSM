extends Node2D

#--------------------------------
# Класс области видимости
# Определяет бегающего, идущего или крадущегося игрока в зависимости от расстояния
#--------------------------------

onready var parent = get_parent()
onready var ray = get_node_or_null("../seekRay")

var see_player: bool
var tied_allies: Array
var player_position: Vector2 setget ,get_player_position
var last_see_position: Vector2

enum checks {none, running, walking, any}
var check = checks.none


func get_player_position() -> Vector2:
	return G.player.global_position


func set_see_player(see: bool):
	see_player = see
	last_see_position = get_player_position()
	var new_state: int
	if see_player:
		new_state = parent.states.attack
	else:
		new_state = parent.states.search
	parent.set_state(new_state)


func set_check(new_check: int):
	check = new_check
	if check == checks.none:
		ray.enabled = false
	else:
		ray.enabled = true


func raycast_see_player() -> bool:
	assert(ray != null, "error: empty ray")
	var dir = get_player_position() - global_position
	ray.scale.x = ray.scale.y * (-1.0 if parent.flip_x else 1.0)
	ray.cast_to = dir
	var result = ray.is_colliding() && ray.get_collider() == G.player
	return result


func _process(_delta) -> void:
	if check == checks.none: return
	if parent.is_tied: return
	var temp_see = raycast_see_player()
	var player = G.player
	match check:
		checks.running:
			if !player.is_running():
				temp_see = false
		checks.walking:
			if player.is_crouching() || player.velocity.length() == 0:
				temp_see = false
	if temp_see: set_see_player(true)
	elif see_player: set_see_player(false)


func _on_body_entered(body, condition):
	if condition == "close" && body is Guard:
		if body.is_tied:
			tied_allies.append(body)
	
	if !see_player && body.name == "flashlight":
		set_see_player(true)
		
	if body.name != "Player": return
	match condition:
		"running":
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
