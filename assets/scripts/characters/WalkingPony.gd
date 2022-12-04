extends Character

#-----------------------------------------------
# Отвечает за передвигающихся через навигацию персонажей
#-----------------------------------------------

class_name WalkingPony

onready var agent = get_node("agent2d")
export var speed = 80
export var start_animation = "idle"

var has_target = false

signal arrived


func _ready():
	change_animation(start_animation)


func _process(_delta):
	if has_target:
		update_moving()


func set_target(target: Vector2):
	agent.set_target_location(target)
	has_target = true


func update_moving():
	if !may_move:
		change_animation(start_animation)
		return
	
	if agent.is_navigation_finished():
		change_animation("idle")
		emit_signal("arrived")
		velocity = Vector2.ZERO
		has_target = false
	else:
		var move_dir = position.direction_to(agent.get_next_location())
		update_walk_velocity(move_dir)
		agent.set_velocity(velocity)
		look_at_direction(move_dir)


func update_walk_velocity(dir: Vector2) -> void:
	velocity = dir * speed
	change_animation("walk")


func look_at_direction(direction: Vector2):
	set_flip_x(direction.x < 0)
