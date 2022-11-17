extends KinematicBody2D

#--------------------------------
# Базовый класс персонажей
# отвечает за анимацию говорения в диалогах
#--------------------------------

class_name Character

export var code: String
onready var anim = get_node("anim")
onready var mouth = get_node("mouth")

var velocity: Vector2

func is_running() -> bool:
	return false


func animate_mouth(time = 0):
	if time > 0:
		mouth.visible = true
		yield(get_tree().create_timer(time), "timeout")
		mouth.visible = false


func set_flip_x(flipOn: bool) -> void:
	$sprite.flip_h = flipOn
	$mouth.flip_h = flipOn


func change_animation(new_animation: String) -> void:
	if anim.current_animation != new_animation:
		anim.current_animation = new_animation
