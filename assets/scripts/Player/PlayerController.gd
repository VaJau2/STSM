extends KinematicBody2D

#--------------------------------
# Отвечает за передвижения игрока
#--------------------------------


export var speed = 120
export var run_speed = 200
export var crouch_speed = 60
export var acceleration = 800

var velocity = Vector2()
var dir = Vector2()

onready var states: PlayerStates = get_node("states")
onready var anim = get_node("anim")


func update_keys() -> void:
	dir = Vector2.ZERO
	
	if states.may_move():
		if Input.is_action_pressed("ui_up"):
			dir.y = -1
		elif Input.is_action_pressed("ui_down"):
			dir.y = 1
		
		if Input.is_action_pressed("ui_left"):
			dir.x = -1
			set_flip_x(true)
		elif Input.is_action_pressed("ui_right"):
			dir.x = 1
			set_flip_x(false)
		
		var shift_is_pressed = Input.is_action_pressed("ui_shift")
		states.set_running(shift_is_pressed)
		
		if Input.is_action_just_pressed("ui_crouch"):
			states.toggle_crouching()


func set_flip_x(flipOn: bool) -> void:
	$sprite.flip_h = flipOn
	$mouth.flip_h = flipOn


func update_velocity(delta: float) -> void:
	var target_speed = get_current_speed()
	velocity = velocity.move_toward(dir * target_speed, acceleration * delta)
	change_animation(get_current_animation())


func get_current_speed() -> int:
	var state = states.moving_states
	
	match states.moving_state:
		state.crouching: return crouch_speed
		state.running: return run_speed
		state.walking: return speed
		_: return 0


func get_current_animation() -> String:
	var state = states.moving_states
	var is_moving = dir.length() > 0
	
	match states.moving_state:
		state.crouching: return "crouch" if is_moving else "crouch-idle"
		state.running: return "run" if is_moving else "idle"
		state.walking: return "walk" if is_moving else "idle"
		_: return "idle"


func change_animation(new_animation: String) -> void:
	if anim.current_animation != new_animation:
		anim.current_animation = new_animation


func _process(delta) -> void:
	update_keys()
	update_velocity(delta)


func _physics_process(_delta) -> void:
	if (velocity.length() > 0):
		velocity = move_and_slide(velocity)
