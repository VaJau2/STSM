extends Node

#--------------------------------
# Синглотн, отвечающий за загрузку сцен, парсинг и тд
#--------------------------------

var dialogue = null
var player = null
var current_scene = null
var grenades_count: int = 10
var loses_count: int = -1
var reload_level: String = "Forest"


func _ready():
	randomize()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func parse_json_data(file, folder = "") -> Dictionary:
	var path = "res://assets/json/"
	if folder != "":
		path += folder + "/"
	path += file + ".json"
	
	var data_file = File.new()
	var open_result = data_file.open(path, File.READ)
	assert(open_result == OK, "error reading json dialogue file in path: " + path)
	
	var data_text = data_file.get_as_text()
	data_file.close()
	
	var parsed_data = JSON.parse(data_text)
	assert(parsed_data.error == OK, "error reading json dialogue file in path: " + path)
	
	return parsed_data.result


func find_character(code: String) -> Character:
	var characters = get_tree().get_nodes_in_group("characters")
	for character in characters:
		if character.code == code:
			return character
	push_error("could not find character named " + code)
	return null


func goto_scene(scene):
	var background = get_node_or_null("/root/Scene/Canvas/background")
	if background != null:
		background.visible = true
		while is_instance_valid(background) && background.color.a < 1:
			background.color.a += 0.01
			yield(get_tree(), "idle_frame")
	call_deferred("_deferred_goto_scene", "res://scenes/" + scene + ".tscn")


func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
