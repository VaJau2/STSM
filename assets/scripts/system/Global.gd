extends Node

var dialogue = null


func _ready():
	randomize()


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
