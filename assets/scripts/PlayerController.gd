extends KinematicBody2D

#--------------------------------
# Отвечает за передвижения игрока
#--------------------------------


export var speed = 120
export var run_speed = 200
export var acceleration = 800

var velocity = Vector2()
var dir = Vector2()

var is_running = false
var may_move = true

onready var anim = get_node("anim")


func update_keys():
	if may_move:
		if (Input.is_action_pressed("ui_shift")):
			is_running = true
		
		if (Input.is_action_pressed("ui_up")):
			dir.y = -1
		elif (Input.is_action_pressed("ui_down")):
			dir.y = 1
		
		if (Input.is_action_pressed("ui_left")):
			dir.x = -1
			set_flip_x(true)
		elif (Input.is_action_pressed("ui_right")):
			dir.x = 1
			set_flip_x(false)


func set_flip_x(flipOn: bool) -> void:
	$sprite.flip_h = flipOn


func update_velocity(delta: float) -> void:
	var temp_speed = run_speed if (is_running) else speed
	velocity = velocity.move_toward(dir * temp_speed, acceleration * delta)
	
	if dir.length() > 0:
		var temp_anim = "run" if (is_running) else "walk"
		change_animation(temp_anim)
	else:
		change_animation("idle")


func change_animation(new_animation: String) -> void:
	anim.current_animation = new_animation


func _process(delta):
	dir = Vector2(0, 0)
	is_running = false
	
	update_keys()
	update_velocity(delta)


func _physics_process(_delta):
	if (velocity.length() > 0):
		velocity = move_and_slide(velocity)
