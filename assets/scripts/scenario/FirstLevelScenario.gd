extends Node

onready var start_label = get_node("../Canvas/Start_label")

export var mother_path: NodePath
export var target_path: NodePath
export var door_path: NodePath
export var phone_path: NodePath
export var strikely_path: NodePath
export var shadows_path: NodePath

var mother: Character
var strikely: Character
var target: Node2D
var door
var phone
var start_pos: Vector2
var shadows


func _ready():
	mother = get_node(mother_path)
	strikely = get_node(strikely_path)
	start_pos = mother.position
	target = get_node(target_path)
	door = get_node(door_path)
	phone = get_node(phone_path)
	shadows = get_node(shadows_path)


func _process(_delta):
	if Input.is_action_just_pressed("ui_space"):
		start_game()
		set_process(false)


func start_game():
	#звонит телефон
	start_label.visible = false
	phone.set_ring(true)
	yield(get_tree().create_timer(3), "timeout")
	
	#приходит желтая пня
	door.open()
	shadows.set_open(true)
	mother.set_target(target.position)
	yield(mother, "arrived")
	phone.set_ring(false)
	phone.set_open(true)
	
	#запускается первый диалог
	G.dialogue.start_dialogue("start_dialogue")
	yield(G.dialogue, "finished")
	
	#желтая пня уходит
	phone.set_open(false)
	mother.set_target(start_pos)
	yield(mother, "arrived")
	mother.queue_free()
	yield(get_tree().create_timer(3), "timeout")
	
	#приходит страйкли
	strikely.set_target(target.position)
	yield(strikely, "arrived")
	door.close()
	shadows.set_open(false)
	
	phone.set_open(true)
	yield(get_tree().create_timer(1), "timeout")
	
	#запускается второй диалог
	G.dialogue.start_dialogue("start_dialogue2")
	yield(G.dialogue, "finished")
	phone.set_open(false)
	yield(get_tree().create_timer(1), "timeout")
	
	#страйкли уходит
	door.open()
	shadows.set_open(true)
	strikely.set_target(start_pos)
	yield(strikely, "arrived")
	strikely.queue_free()
	door.close()
	shadows.set_open(false)
