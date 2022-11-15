extends Control

onready var label = get_node("back/text")
onready var name_label = get_node("back/name")
onready var continue_label = get_node("back/continue")

var nodes = {}
var may_continue = false
var may_exit = false
signal next_node


func start_dialogue(file):
	var path = "res://assets/dialogues/" + file + ".json";
	var data_file = File.new()
	if data_file.open(path, File.READ) != OK:
		push_error("error reading json dialogue file in path: " + path)
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		push_error("error parsing json data in path: " + path)
		return
	nodes = data_parse.result
	show_node(0)


func show_node(node):
	if node < nodes.size():
		visible = true
		var temp_node = nodes[str(node)]
		name_label.text = temp_node.name
		label.text = temp_node.text
		label.percent_visible = 0
		while label.percent_visible < 1:
			label.percent_visible += 0.05
			yield(get_tree(), "idle_frame")
		set_may_continue(true)
		yield(self, "next_node")
		show_node(node + 1)
	else:
		visible = false


func set_may_continue(may):
	continue_label.visible = may
	may_continue = may


func _process(_delta):
	if may_continue && Input.is_action_just_pressed("ui_space"):
		set_may_continue(false)
		emit_signal("next_node")
	
	if Input.is_action_just_pressed("ui_interact"):
		start_dialogue("start_dialogue")
