extends Node

onready var start_label = get_node("../Canvas/StartLabel")
onready var skip_label = get_node("../Canvas/SkipLabel")
onready var timer = get_node("Timer")

export var mother_path: NodePath
export var target_path: NodePath
export var door_path: NodePath
export var phone_path: NodePath
export var strikely_path: NodePath
export var shadows_path: NodePath

var mother: Character
var strikely: Character
var target: Node2D
var door = null
var phone = null
var start_pos: Vector2
var shadows = null

var may_skip: bool = false
var game_started: bool = false


func _ready() -> void:
	mother = get_node(mother_path)
	strikely = get_node(strikely_path)
	start_pos = mother.position
	target = get_node(target_path)
	door = get_node(door_path)
	phone = get_node(phone_path)
	shadows = get_node(shadows_path)


func _process(_delta: float) -> void:
	if !game_started:
		if Input.is_action_just_pressed("ui_space"):
			start_game()
	
	if may_skip:
		if Input.is_action_just_pressed("ui_flashlight"):
			G.goto_scene("Road")


func set_may_skip(on: bool) -> void:
	skip_label.visible = on
	may_skip = on


func start_game() -> void:
	#звонит телефон
	game_started = true
	start_label.visible = false
	phone.set_ring(true)
	timer.start(3)
	yield(timer, "timeout")

	#приходит желтая пня
	door.open()
	shadows.set_open(true)
	mother.set_target(target.position)
	yield(mother, "arrived")
	phone.set_ring(false)
	phone.set_open(true)
	set_may_skip(true)

	#запускается первый диалог
	G.dialogue.start_dialogue("start")
	yield(G.dialogue, "finished")

	#желтая пня уходит
	phone.set_open(false)
	mother.set_target(start_pos)
	yield(mother, "arrived")
	mother.queue_free()
	timer.start(3)
	yield(timer, "timeout")

	#приходит страйкли
	strikely.set_target(target.position)
	yield(strikely, "arrived")
	door.close()
	shadows.set_open(false)

	phone.set_open(true)
	timer.start(1)
	yield(timer, "timeout")

	#запускается второй диалог
	G.dialogue.start_dialogue("start2")
	yield(G.dialogue, "finished")
	phone.set_open(false)
	set_may_skip(false)
	timer.start(1)
	yield(timer, "timeout")

	#страйкли уходит
	door.open()
	shadows.set_open(true)
	strikely.set_target(start_pos)
	yield(strikely, "arrived")
	strikely.queue_free()
	door.close()
	shadows.set_open(false)
	
	#переход на следующую сцену
	timer.start(2)
	yield(timer, "timeout")
	G.goto_scene("Road")
