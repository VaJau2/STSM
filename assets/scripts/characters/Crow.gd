extends Character

#--------------------------------
# Класс ворона
# Реализован через отдельный класс, т.к. не использует навигацию
# и летает сквозь коллизию
#--------------------------------

const SPEED = 300
const ARRIVE_DISTANCE = 10

const FLY_CHANCE = 0.5

const MIN_IDLE = 4
const MAX_IDLE = 10

export (Array, NodePath) var random_points_path
export var follow_target_path: NodePath
export var minimap_icon: String = "animal"
var follow_target: Character

var random_points: Array
var idle_timer: float
var is_flying: bool = false
var flying_target: Vector2


signal arrived


func _ready() -> void:
	follow_target = get_node(follow_target_path)
	for point_path in random_points_path:
		random_points.append(get_node(point_path))


func _process(delta) -> void:
	if is_flying:
		update_moving()
		return
	elif idle_timer > 0:
		idle_timer -= delta
	else:
		get_new_state()


func get_new_state() -> void:
	if randf() > FLY_CHANCE:
		get_random_fly_dir()
		return
	
	change_animation("idle")
	idle_timer = rand_range(MIN_IDLE, MAX_IDLE)


func get_random_fly_dir() -> void:
	if random_points.size() == 0:
		return
	var target_pos = follow_target.position
	var closestI = 0
	var closestDistance = random_points[closestI].position.distance_to(target_pos)
	for pointI in range(random_points.size()):
		var point = random_points[pointI]
		var tempDistance = point.position.distance_to(target_pos)
		if tempDistance < closestDistance:
			closestDistance = tempDistance
			closestI = pointI
	set_target(random_points[closestI].position)


func set_target(target: Vector2) -> void:
	flying_target = target
	is_flying = true


func update_moving() -> void:
	if !may_move:
		change_animation("idle")
		return

	if is_arrived():
		change_animation("idle")
		emit_signal("arrived")
		velocity = Vector2.ZERO
		is_flying = false
	else:
		var move_dir = position.direction_to(flying_target)
		look_at_direction(move_dir)
		change_animation("fly")
		velocity = move_dir * SPEED


func look_at_direction(direction: Vector2) -> void:
	set_flip_x(direction.x < 0)


func is_arrived() -> bool:
	return position.distance_to(flying_target) < ARRIVE_DISTANCE
