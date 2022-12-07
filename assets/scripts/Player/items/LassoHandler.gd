extends Node2D

const COOLDOWN_TIME = 2
const THROW_DISTANCE = 200
const START_SPEED = 4.5

onready var parent = get_parent()
onready var item = get_node("../item")
onready var lasso_parent = get_node("/root/Scene")
onready var line = get_node("line")
onready var audi = get_node("audi")

var lasso_prefab = preload("res://objects/items/lasso.tscn")
var lasso = null
var cooldown: float = COOLDOWN_TIME


func set_item_on(on: bool) -> void:
	if on:
		if lasso == null: 
			item.visible = true
	else:
		if lasso != null: clean_lasso()
		item.visible = false
	set_process(on)


func clean_lasso() -> void:
	line.points[1] = Vector2.ZERO
	if is_instance_valid(lasso):
		lasso.queue_free()
	lasso = null
	cooldown = COOLDOWN_TIME
	item.visible = true


func spawn_lasso(victim_pos: Vector2, distance: float) -> void:
	item.visible = false
	lasso = lasso_prefab.instance()
	lasso.handler = self
	var dir = global_position.direction_to(victim_pos)
	lasso.velocity = dir * distance * START_SPEED
	lasso_parent.add_child(lasso)
	lasso.global_position = global_position
	audi.play()


func update_line() -> void:
	if !is_instance_valid(lasso): 
		line.points[1] = Vector2.ZERO
	else:
		var line_pos = lasso.global_position - global_position
		line.points[1] = line_pos
		line.scale.x = line.scale.y * (-1.0 if parent.flip_x else 1.0)


func _process(delta: float) -> void:
	if lasso != null: 
		update_line()
		return
	
	if parent.state != parent.states.attack: return
	if parent.is_stunned: return
	if parent.player_is_tied(): return
	
	var victim_pos = parent.seek_area.victim_position
	var distance = global_position.distance_to(victim_pos)
	if distance > THROW_DISTANCE: return
	
	if cooldown > 0:
		cooldown -= delta
	else:
		spawn_lasso(victim_pos, distance)
