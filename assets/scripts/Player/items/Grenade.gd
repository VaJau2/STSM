extends RigidBody2D

const AIR_FRICTION = 1.02
const MIN_SPEED = 20


func _integrate_forces(state):
	if state.linear_velocity.length() < MIN_SPEED:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
	else:
		state.linear_velocity = state.linear_velocity / AIR_FRICTION
		state.angular_velocity = state.angular_velocity / AIR_FRICTION
