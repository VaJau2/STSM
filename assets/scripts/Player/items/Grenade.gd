extends RigidBody2D

const AIR_FRICTION = 1.02
const MIN_SPEED = 20
const EXPLODE_TIME = 3

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
	$audi.play()
	$explode.visible = true
	for victim in victims:
		victim.stun()
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()


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
