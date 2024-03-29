extends Node2D

onready var icon = get_node("/root/Scene/Canvas/FlashlightIcon")
onready var detect_body_shape = get_node_or_null("flashlight/shape")
var flashlight_sound: AudioStream = preload("res://assets/audio/items/flashlight.wav")

export var audi_path: NodePath
var audi: AudioStreamPlayer2D


func set_on(on: bool) -> void:
	audi.stream = flashlight_sound
	audi.play()
	visible = on
	icon.set_on(on)
	if detect_body_shape != null:
		detect_body_shape.disabled = !on


func _ready():
	audi = get_node(audi_path)


func _process(_delta):
	if !visible: return
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	rotation_degrees = clamp(rotation_degrees, -60, 60)
