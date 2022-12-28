extends KinematicBody2D


var handler = null
var velocity: Vector2
var start_timer = 0.4


func make_say(phrase: String, chance: float):
	var phrases = handler.parent.phrases
	if phrases:
		phrases.say(phrase, chance)


func _process(delta: float) -> void:
	if start_timer > 0:
		start_timer -= delta
		return
	
	if velocity.length() > 0.1:
		velocity *= 0.5
	else:
		handler.clean_lasso()


func _physics_process(_delta):
	velocity = move_and_slide(velocity)


func _on_area_body_entered(body):
	if body.name != "Player": return
	make_say("success", 0.8)
	body.tie()
	queue_free()
