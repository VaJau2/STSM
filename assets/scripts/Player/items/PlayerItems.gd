extends Sprite

#--------------------------------
# Отвечает за включение фонарика и гранат
#--------------------------------

export var light_handler_path: NodePath
export var grenade_handler_path: NodePath


var flashlight: Texture = preload("res://assets/sprites/items/flashlight/flashlight_item.png")
var flashlight_on: bool = false
var light_handler = null

var grenade: Texture = preload("res://assets/sprites/items/grenade/grenade_item.png")
var grenade_on: bool = false
var grenade_handler = null


func set_flashlight_on(on: bool) -> void:
	if grenade_on: set_grenade_on(false)
	flashlight_on = on
	texture = flashlight if on else null
	light_handler.set_on(on)


func set_grenade_on(on: bool) -> void:
	if G.grenades_count <= 0 and on: return
	if flashlight_on: set_flashlight_on(false)
	grenade_on = on
	texture = grenade if on else null
	grenade_handler.set_on(on)


func _ready():
	light_handler = get_node(light_handler_path)
	grenade_handler = get_node(grenade_handler_path)


func _process(_delta):
	if Input.is_action_just_pressed("ui_flashlight"):
		set_flashlight_on(!flashlight_on)
	if Input.is_action_just_pressed("ui_grenade"):
		set_grenade_on(!grenade_on)
