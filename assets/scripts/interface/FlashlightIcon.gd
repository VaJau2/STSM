extends Control

var icon_on = preload("res://assets/sprites/items/flashlight/flashlight_icon_on.png")
var icon_off = preload("res://assets/sprites/items/flashlight/flashlight_icon_off.png")

onready var sprite = get_node("TextureRect")

func set_on(on: bool) -> void:
	sprite.texture = icon_on if on else icon_off
	
