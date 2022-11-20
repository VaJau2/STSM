extends KinematicBody2D

const DEFAULT_IDLE_ANIM = "idle"
const MIN_IDLE = 4
const MAX_IDLE = 10
const MIN_WALK = 5
const MAX_WALK = 8

export var idle_animations: PoolStringArray
export var dialogue_code: String

onready var anim = $anim

var idle_timer: float


func _ready() -> void:
	get_new_state()


func _process(delta) -> void:
	if idle_timer > 0:
		idle_timer -= delta
	else:
		get_new_state()


func get_new_state():
	anim.current_animation = get_random_idle()
	idle_timer = rand_range(MIN_IDLE, MAX_IDLE)


func get_random_idle() -> String:
	if idle_animations.size() == 0:
		return DEFAULT_IDLE_ANIM
		
	var randI = randi() % idle_animations.size()
	return idle_animations[randI]


func get_random_walk_dir():
	pass
