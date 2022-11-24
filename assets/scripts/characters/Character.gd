extends KinematicBody2D

#--------------------------------
# Базовый класс персонажей
# отвечает за анимацию говорения в диалогах
#--------------------------------

class_name Character

export var code: String
onready var anim = get_node("anim")
onready var mouth = get_node("mouth")
onready var item_sprite = get_node("item")
onready var sound_steps = get_node("soundSteps")

var land_material = "snow"
var velocity: Vector2
var flip_x: bool


func is_running() -> bool:
	return false


func is_on_snow() -> bool:
	return land_material == "snow"


func is_hiding() -> bool:
	return false


func is_crouching() -> bool:
	return false


func set_land_material(material: String):
	land_material = material


func animate_mouth(time = 0):
	if time > 0:
		mouth.visible = true
		yield(get_tree().create_timer(time), "timeout")
		mouth.visible = false


func set_flip_x(flip_on: bool) -> void:
	if flip_x == flip_on: return
	flip_x = flip_on
	if flip_x:
		scale.x = scale.y * -1
	else:
		scale.x = scale.y * 1


func change_animation(new_animation: String) -> void:
	if anim.current_animation != new_animation:
		anim.current_animation = new_animation
