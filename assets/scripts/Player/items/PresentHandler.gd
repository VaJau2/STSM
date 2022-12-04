extends Sprite

#--------------------------------
# Груз, который тащит игрок
#--------------------------------

var present_item_prefab = preload("res://objects/items/Present.tscn")
var check_states_change: bool = false


func set_on() -> void:
	visible = true
	yield(get_tree(), "idle_frame")
	check_states_change = true


func _on_states_changed():
	if !check_states_change: return
	visible = false
	check_states_change = false
	var item = present_item_prefab.instance()
	var parent = get_node("/root/Scene/YSort")
	parent.add_child(item)
	item.global_position = get_parent().global_position
	item.spawn_marker()
