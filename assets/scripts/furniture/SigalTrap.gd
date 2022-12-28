extends KinematicBody2D


#--------------------------------
# Сигнальная ловушка
# Срабатывает при наступании и триггерит врагов вокруг
#--------------------------------

const MAX_DISTANCE = 1500
const DELETE_CHANCE = 0.6

var sprite_on_light = preload("res://assets/sprites/background/base/signal-trap/trap-on-light.png")
var sprite_on = preload("res://assets/sprites/background/base/signal-trap/trap-on.png")
var unlock_sound = preload("res://assets/audio/furniture/trap_unlock.wav")
var done: bool = false
var may_interact: bool setget ,get_may_interact


func get_may_interact() -> bool:
	return !done && G.player.is_crouching()


func interact(_player) -> void:
	$sprite.texture = sprite_on
	$shadow.queue_free()
	$audi.stream = unlock_sound
	$audi.play()
	done = true


func trigger_guards():
	var characters = get_tree().get_nodes_in_group("characters")
	for character in characters:
		if !character is Guard: continue
		var distance = global_position.distance_to(character.global_position)
		if distance > MAX_DISTANCE: continue
		character.set_search_position(global_position)


func _ready():
	if randf() < DELETE_CHANCE:
		queue_free()


func _on_area_body_entered(body):
	if done: return
	if body.name == "Player":
		trigger_guards()
		$sprite.texture = sprite_on_light
		$shadow.queue_free()
		$audi.play()
		done = true
		yield(get_tree().create_timer(1), "timeout")
		$sprite.texture = sprite_on
