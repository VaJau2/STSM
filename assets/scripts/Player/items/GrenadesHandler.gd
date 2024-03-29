extends Node2D

export var audi_path: NodePath

onready var grenades_parent = get_node("/root/Scene/YSort")
onready var grenades_count_label = get_node_or_null("/root/Scene/Canvas/GrenadesCount")
onready var items_handler = get_node("../item")
onready var player = get_parent()
var grenade_prefab = preload("res://objects/items/grenade.tscn")

var grenade_sound: AudioStream = preload("res://assets/audio/items/grenade_throw.wav")

var audi: AudioStreamPlayer2D

var is_on: bool = false
var start_speed = 250
var grenades_count: int


func save_to_global() -> void:
	G.grenades_count = grenades_count


func set_on(on: bool) -> void:
	is_on = on
	set_process(on)


func _ready() -> void:
	grenades_count = G.grenades_count
	if grenades_count_label == null:
		set_process(false)
		return
	audi = get_node(audi_path)
	set_on(false)
	show_grenades_count()


func get_dir() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	return global_position.direction_to(mouse_pos) * 250


func spawn_grenade(dir: Vector2) -> void:
	var grenade = grenade_prefab.instance()
	grenades_parent.add_child(grenade)
	grenade.global_position = global_position
	grenade.linear_velocity = dir
	grenade.angular_velocity = rand_range(20, 50)
	audi.stream = grenade_sound
	audi.play()


func show_grenades_count() -> void:
	grenades_count_label.grenades_count_change(grenades_count)


func _process(_delta: float) -> void:
	if grenades_count <= 0:
		items_handler.set_grenade_on(false)
		set_process(false)
		return
	
	if Input.is_action_just_pressed("mouse_0") && player.may_move:
		var dir = get_dir()
		spawn_grenade(dir)
		grenades_count -= 1
		show_grenades_count()
