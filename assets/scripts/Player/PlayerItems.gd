extends Sprite

#--------------------------------
# Отвечает за включение фонарика, гранат..
#--------------------------------

export var light_spot_path: NodePath
export var audi_path: NodePath

var flashlight: Texture = preload("res://assets/sprites/items/flashlight.png")
var flashlight_sound: AudioStream = preload("res://assets/audio/items/flashlight.wav")
var flashlight_on: bool = false
var light_spot: Node2D
var audi: AudioStreamPlayer2D


func set_flashlight_on(on: bool) -> void:
	flashlight_on = on
	texture = flashlight if on else null
	light_spot.visible = on
	audi.stream = flashlight_sound
	audi.play()


func _ready():
	light_spot = get_node(light_spot_path)
	audi = get_node(audi_path)


func _process(_delta):
	if Input.is_action_just_pressed("ui_flashlight"):
		set_flashlight_on(!flashlight_on)
