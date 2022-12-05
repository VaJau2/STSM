extends Area2D

onready var player = get_parent()
var interact_objects = []


func _on_interaction_body_entered(body):
	if !player.may_move: return
	if body.has_method("interact") && body.may_interact == true:
		interact_objects.append(body)
		update_hint()


func _on_interaction_body_exited(body):
	if interact_objects.has(body):
		interact_objects.erase(body)
		update_hint()


func update_hint():
	$hint.visible = interact_objects.size() > 0


func _input(event):
	if event is InputEventKey && Input.is_action_just_pressed("ui_interact"):
		if interact_objects.size() > 0:
			var key = interact_objects.size() - 1
			interact_objects[key].interact(player)
