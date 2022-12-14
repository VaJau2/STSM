extends Area2D

onready var player = get_parent()
var interact_objects = []
var temp_object = null


func _on_interaction_body_entered(body: Object) -> void:
	if !player.may_move: return
	if body.has_method("interact"):
		interact_objects.append(body)
		if temp_object == null:
			update_temp_object()


func _on_interaction_body_exited(body: Object) -> void:
	if interact_objects.has(body):
		interact_objects.erase(body)
		if body == temp_object:
			clean_temp_object()
			update_temp_object()


func _process(_delta: float) -> void:
	if temp_object == null: return
	
	if !temp_object.may_interact:
		clean_temp_object()
		update_temp_object()
		return
	
	if Input.is_action_just_pressed("ui_interact"):
		temp_object.interact(player)


func clean_temp_object() -> void:
	temp_object = null
	$hint.visible = false


func update_temp_object() -> void:
	var closest_object = find_closest_object()
	if closest_object == null: return
	temp_object = closest_object
	$hint.visible = true


func find_closest_object() -> Object:
	var temp_interactable_objects = get_interactable_objects()
	if temp_interactable_objects.size() == 0: return null
	var closest_object = temp_interactable_objects[0]
	var closest_distance = global_position.distance_to(closest_object.global_position)
	for object in temp_interactable_objects:
		var temp_distance = global_position.distance_to(object.global_position)
		if temp_distance < closest_distance: 
			closest_object = object
			closest_distance = temp_distance
	return closest_object


func get_interactable_objects() -> Array:
	var result = []
	for object in interact_objects:
		if object.may_interact == false: continue
		result.append(object)
	return result
