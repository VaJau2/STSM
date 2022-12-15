extends RigidBody2D

const AIR_FRICTION = 1.02
const MIN_SPEED = 20
const EXPLODE_TIME = 1.25
const PLAYER_CHECK_STUN_DISTANCE = 65

onready var ray: RayCast2D = get_node("ray")

var timer: float
var victims: Array


func _integrate_forces(state) -> void:
	if state.linear_velocity.length() < MIN_SPEED:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
	else:
		state.linear_velocity = state.linear_velocity / AIR_FRICTION
		state.angular_velocity = state.angular_velocity / AIR_FRICTION


func explode() -> void:
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	$audi.play()
	$explode.visible = true
	for victim in victims:
		if may_stun_victim(victim): victim.stun()
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()


func may_stun_victim(victim: Character) -> bool:
	if !raycast_see_victim(victim): return false
	if victim.name == "Player":
		var distance = global_position.distance_to(victim.global_position)
		if distance < PLAYER_CHECK_STUN_DISTANCE: return true
		
		if victim.global_position.x > global_position.x:
			return victim.flip_x
		else:
			return !victim.flip_x
	return true


func raycast_see_victim(victim: Character) -> bool:
	var dir = victim.global_position - global_position
	ray.rotation = -rotation 
	ray.cast_to = dir
	ray.enabled = true
	ray.force_raycast_update()
	var result = ray.is_colliding() && ray.get_collider() == victim
	ray.enabled = false
	return result


func _process(delta: float) -> void:
	if timer < EXPLODE_TIME:
		timer += delta
	else:
		explode()
		set_process(false)


func _on_area_body_entered(body):
	if body is Character && body.has_method("stun"):
		victims.append(body)


func _on_area_body_exited(body):
	if victims.has(body):
		victims.erase(body)
