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
signal next_node


func start_dialogue(file) -> void:
	nodes = G.parse_json_data(file, "dialogues")
	show_node(0)


func show_node(node) -> void:
	if node < nodes.size():
		visible = true
		var temp_node = nodes[str(node)]
		
		if temp_node.has("config_code"):
			audi.set_config(temp_node.config_code)
		else:
			audi.set_config(null)
		
		name_label.text = temp_node.name
		label.text = temp_node.text
		label.percent_visible = 0
		
		while label.percent_visible < 1:
			label.visible_characters += 1
			var last_letter = get_last_letter()
			audi.play_dialogue_sound(label.visible_characters, last_letter)
			yield(get_tree().create_timer(timer), "timeout")
		
		set_may_continue(true)
		yield(self, "next_node")
		show_node(node + 1)
	else:
		visible = false


func get_last_letter() -> String:
	return label.text[label.visible_characters - 1]


func set_may_continue(may) -> void:
	continue_label.visible = may
	may_continue = may


func _process(_delta) -> void:
	if may_continue && Input.is_action_just_pressed("ui_space"):
		set_may_continue(false)
		emit_signal("next_node")
	
	if Input.is_action_just_pressed("ui_interact"):
		start_dialogue("start_dialogue")
