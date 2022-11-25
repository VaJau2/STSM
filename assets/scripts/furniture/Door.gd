extends StaticBody2D

export var open_sprite: Texture
export var closed_sprite: Texture
export var open_sound: AudioStream
export var close_sound: AudioStream
export var opened = false

onready var sprite: Sprite = get_node("Door")
onready var audi: AudioStreamPlayer2D = get_node("audi")
var closed: bool = true
var may_interact = true


func _ready():
	if opened:
		open(false)


func interact(_interactor):
	if closed: 
		open()
	else:
		close()


func open(sound = true):
	closed = false
	sprite.texture = open_sprite
	collision_layer = 2
	collision_mask = 2
	if sound:
		audi.stream = open_sound
		audi.play()


func close(sound = true):
	closed = true
	sprite.texture = closed_sprite
	collision_layer = 1
	collision_mask = 1
	if sound:
		audi.stream = close_sound if close_sound != null else open_sound
		audi.play()
