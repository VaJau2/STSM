extends KinematicBody2D

#--------------------------------
# Базовый класс персонажей
# отвечает за анимацию говорения в диалогах
# и за функции состояния, которые переопределяются в дочерних классах
#--------------------------------

class_name Character

const MATERIAL_ACCELS = {
	"snow": 1000,
	"ice": 200
}
const DEFAULT_MATERIAL = "snow"

export var code: String

onready var anim = get_node("anim")
onready var mouth = get_node_or_null("mouth")
onready var item_sprite = get_node_or_null("item")
onready var sound_steps = get_node_or_null("soundSteps")

var land_material = "snow"
var velocity: Vector2
var acceleration = MATERIAL_ACCELS.snow
var flip_x: bool
var may_move: bool = true


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
	if sound_steps != null:
		sound_steps.set_land_material(material)
	
	if MATERIAL_ACCELS.has(material):
		acceleration = MATERIAL_ACCELS[material]
	else:
		acceleration = MATERIAL_ACCELS[DEFAULT_MATERIAL]


func animate_mouth(time = 0):
	if time > 0:
		mouth.visible = true
		yield(get_tree().create_timer(time), "timeout")
		mouth.visible = false


func set_flip_x(flip_on: bool) -> void:
	if flip_x == flip_on: return
	flip_x = flip_on
	scale.x = scale.y * (-1.0 if flip_x else 1.0)


func change_animation(new_animation: String) -> void:
	if anim.current_animation != new_animation:
		anim.current_animation = new_animation


func _physics_process(_delta) -> void:
	if may_move && velocity.length() > 0:
		velocity = move_and_slide(velocity)
