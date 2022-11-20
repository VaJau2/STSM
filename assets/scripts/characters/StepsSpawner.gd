extends Node2D

const MAX_STEPS_COUNT = 40
const WALK_SPAWN_TIMER = 0.1
const ALLOWED_FRAMES = [
	0, 1, 8, 9, 10, 11, 12, 13, 14, 15, 16, 
	17, 18, 19, 20, 21, 22, 23, 32, 33
]

onready var parent = get_parent()
var steps_parent

var walk_timer = 0
var idle_onetime = false
var hide_onetime = false

var step_prefab = preload("res://objects/characters/step.tscn")



func _ready():
	steps_parent = get_node_or_null("/root/Scene/steps_parent")
	if steps_parent == null:
		set_process(false)


func spawn_step():
	var current_frame = parent.get_node("sprite").frame
	if idle_onetime:
		if hide_onetime:
			current_frame = 32
		else:
			current_frame = 0
	if !ALLOWED_FRAMES.has(current_frame): return
	
	var new_step = step_prefab.instance()
	steps_parent.add_child(new_step)
	new_step.global_position = global_position
	new_step.frame = current_frame
	new_step.flip_h = parent.flip_x
	idle_onetime = false
	hide_onetime = false
	
	if steps_parent.get_child_count() > MAX_STEPS_COUNT:
		steps_parent.get_child(0).queue_free()


func _process(delta):
	if !parent.is_on_snow(): return
	
	if parent.velocity.length() > 0:
		if !idle_onetime && walk_timer > 0:
			walk_timer -= delta
		else:
			spawn_step()
			walk_timer = WALK_SPAWN_TIMER
	else:
		if parent.is_hiding():
			hide_onetime = true
		idle_onetime = true
