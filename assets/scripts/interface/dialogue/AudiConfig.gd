extends Node

#--------------------------------
# Отвечает за настройки "голоса" в диалогах
#--------------------------------

class_name AudiConfig

var temp_code = ""
var sounds = []
var min_pitch = 0.5
var max_pitch = 3
var chars_to_sound = 3


func load_from_file(code) -> void:
	if temp_code == code: return
	
	var configs_data = G.parse_json_data("audi_configs")
	var config = configs_data[code]
	for key in config["sounds"]:
		var sound = "res://assets/audio/dialogue/" + config["sounds"][key]
		sounds.append(load(sound))
	min_pitch = float(config["min_pitch"])
	max_pitch = float(config["max_pitch"])
	chars_to_sound = int(config["chars_to_sound"])
	temp_code = code
