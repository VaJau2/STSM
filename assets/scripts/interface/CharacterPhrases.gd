extends Node2D

const COOLDOWN = 1

onready var label = get_node("back/Label")
var timer: float
var cooldown: float


func say(code: String, chance: float) -> void:
	if randf() > chance: return
	if cooldown > 0: return
	label.text = get_random_phrase(code)
	timer = clamp(label.text.length() / 2, 1, 6)
	cooldown = COOLDOWN
	visible = true


func get_random_phrase(code: String) -> String:
	var all_phrases_data = G.parse_json_data("phrases")
	assert(all_phrases_data.has(code), "no such phrases - " + code)
	var phrases_data = all_phrases_data[code]
	var randI = randi() % phrases_data.size()
	return phrases_data[str(randI)]


func _process(delta: float) -> void:
	if cooldown > 0 && !visible:
		cooldown -= delta
	
	if !visible: return
	if timer > 0:
		timer -= delta
	else:
		
		visible = false
