extends MarginContainer

const OFFSET = 15

export var player_path: NodePath
export var zoom = 1.5

onready var grid = get_node("MarginContainer")
onready var icons = {
	"animal": get_node("MarginContainer/animal"),
	"enemy": get_node("MarginContainer/enemy"),
	"mission": get_node("MarginContainer/mission")
}

var grid_scale: Vector2
var markers: Dictionary
var player = null


func get_marker_pos(item) -> Vector2:
	var pos_by_player = item.position - player.position
	return pos_by_player * grid_scale + grid.rect_size / 2


func update_marker(item) -> void:
	var marker_pos = get_marker_pos(item)
	
	match item.minimap_icon:
		"mission":
			if grid.get_rect().has_point(marker_pos + grid.rect_position):
				markers[item].scale = Vector2(1, 1)
			else:
				markers[item].scale = Vector2(.75, .75)
			marker_pos.x = clamp(marker_pos.x, OFFSET, grid.rect_size.x - OFFSET)
			marker_pos.y = clamp(marker_pos.y, OFFSET, grid.rect_size.y - OFFSET)
		
	markers[item].position = marker_pos


func _ready():
	set_process(false)
	player = get_node(player_path)
	var viewport_zoom = get_viewport_rect().size * zoom
	grid_scale = grid.rect_size / viewport_zoom
	
	var map_objects = get_tree().get_nodes_in_group("minimap_object")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker


func _process(_delta):
	for item in markers:
		update_marker(item)
