extends Character

#-----------------------------------------------
# Отвечает за передвигающихся через навигацию персонажей
#-----------------------------------------------

class_name WalkingPony

const STUN_TIME = 8

onready var agent = get_node("agent2d")
export var speed = 80
export var start_animation = "idle"

var has_target = false

var is_stunned: bool = false
var stun_timer: float = 0

signal arrived


func _ready() -> void:
	change_animation(start_animation)


func _process(delta: float) -> void:
	if is_stunned:
		if stun_timer > 0:
			stun_timer -= delta
		else:
			set_is_stunned(false)
		
	if has_target:
		update_moving(delta)


func set_target(target: Vector2) -> void:
	agent.set_target_location(target)
	has_target = true


func set_is_stunned(value: bool) -> void:
	is_stunned = value
	may_move = !value
	stun_timer = STUN_TIME if value else 0


func stun() -> void:
	set_is_stunned(true)


func update_moving(delta: float) -> void:
	if !may_move: 
		velocity = Vector2.ZERO
		return
	
	if agent.is_navigation_finished():
		emit_signal("arrived")
		velocity = Vector2.ZERO
		change_animation("idle")
		has_target = false
	else:
		var move_dir = position.direction_to(agent.get_next_location())
		update_velocity(move_dir, delta)
		agent.set_velocity(velocity)
		look_at_direction(move_dir)


func update_velocity(dir: Vector2, delta: float) -> void:
	velocity = velocity.move_toward(dir * speed, acceleration * delta)
	change_animation("walk" if dir.length() > 0 else "idle")


func look_at_direction(direction: Vector2):
	set_flip_x(direction.x < 0)
