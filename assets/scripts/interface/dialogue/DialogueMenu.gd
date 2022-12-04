extends Control

#--------------------------------
# Отвечает за отображение диалогов
#--------------------------------

onready var label = get_node("back/text")
onready var name_label = get_node("back/name")
onready var continue_label = get_node("back/continue")
onready var audi = get_node("audi")

var timer = 0.03

var nodes = {}
var may_continue = false
var may_exit = false
var skip = false

signal next_node
signal finished


func start_dialogue(file) -> void:
	if visible: return
	nodes = G.parse_json_data(file, "dialogues")
	show_node(0)


func show_node(node) -> void:
	if node < nodes.size():
		visible = true
		skip = false
		var temp_node = nodes[str(node)]
		var node_timer = temp_node["timer"] if temp_node.has("timer") else timer
		var character = null
		if temp_node.has("character"):
			character = G.find_character(temp_node["character"])
		
		if temp_node.has("config_code"):
			audi.set_config(temp_node.config_code)
		else:
			audi.set_config(null)
		
		name_label.text = temp_node.name
		label.text = ""
		var count = 0
		var count_target = temp_node.text.length()
		
		while count < count_target:
			if skip:
				label.text = temp_node.text
				count = count_target
			else:
				var new_symbol = temp_node.text[count]
				label.text += new_symbol
				count += 1
				audi.play_dialogue_sound(count, new_symbol, character)
				var temp_timer = get_timer(node_timer, new_symbol)
				yield(get_tree().create_timer(temp_timer), "timeout")
		
		set_may_continue(true)
		yield(self, "next_node")
		show_node(node + 1)
	else:
		visible = false
		emit_signal("finished")


func get_timer(node_timer, new_symbol):
	match new_symbol:
		".", "!", "?": return node_timer + 0.4
		",": return node_timer + 0.1
		_: return node_timer


func set_may_continue(may) -> void:
	continue_label.visible = may
	may_continue = may


func _ready():
	G.dialogue = self


func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_space"):
		if may_continue:
			set_may_continue(false)
			emit_signal("next_node")
		else:
			skip = true
