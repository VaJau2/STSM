extends AudioStreamPlayer

#--------------------------------
# Отвечает за озвучивание диалогов
#--------------------------------

const MAX_SAVED_CONFIGS = 3

var config: AudiConfig
var saved_configs = {}


func set_config(code) -> void:
	if code == null: 
		config = null
		return
	
	if config != null && code == config.temp_code: 
		return
	
	if saved_configs.has(code):
		config = saved_configs[code]
		return
	
	var new_config = AudiConfig.new()
	new_config.load_from_file(code)
	config = new_config
	saved_configs[code] = new_config
	
	if saved_configs.size() > MAX_SAVED_CONFIGS:
		var keys_size = saved_configs.keys().size()
		var last_key = saved_configs.keys()[keys_size - 1]
		saved_configs.erase(last_key)


func play_dialogue_sound(visible_chars, symbol, character) -> void:
	if config == null: return
	if symbol == ".": return
	if visible_chars % config.chars_to_sound == 0:
		choose_sound(symbol)
		play()
		if character != null:
			character.animate_mouth(0.05)


func choose_sound(symbol) -> void:
	var temp_hash = get_hash(symbol)
	var soundI = temp_hash % config.sounds.size()
	var sound = config.sounds[soundI]
	stream = sound
	
	var min_pitch_int = int(config.min_pitch * 100)
	var max_pitch_int = int(config.max_pitch * 100)
	var pitch_range = max_pitch_int - min_pitch_int
	if pitch_range != 0:
		var temp_pitch = (temp_hash % pitch_range) + min_pitch_int
		pitch_scale = temp_pitch / 100.0
	else:
		pitch_scale = config.min_pitch


func get_hash(symbol) -> int:
	var sha1_hash = symbol.sha1_text()
	sha1_hash = sha1_hash.substr(0, 10)
	return sha1_hash.to_int()
