extends Sprite

#--------------------------------
# Груз, который тащит игрок
# Может быть подарком или связанным врагом
#--------------------------------

onready var scene_parent = get_node("/root/Scene/YSort")
onready var player = get_parent()
var temp_item = null

var sprites = {
	"present": preload("res://assets/sprites/items/present/present_item.png"),
	"guard": preload("res://assets/sprites/items/guard_item.png")
}


func set_on(item_type: String, item) -> void:
	if !sprites.keys().has(item_type): return
	temp_item = item
	temp_item.visible = false
	temp_item.global_position = Vector2(-999, -999)
	texture = sprites[item_type]
	visible = true
	if item_type == "present":
		player.has_present = true


func _on_states_changed():
	if !visible: return
	temp_item.visible = true
	var new_pos = get_parent().global_position
	new_pos.y += 10
	temp_item.global_position = new_pos
	temp_item = null
	visible = false
	player.has_item = false
	player.has_present = false
