extends Node

const NEXT_LEVEL = "Forest"

onready var skip_label = get_node("../Canvas/SkipLabel")
onready var timer = get_node("Timer")

var may_skip: bool = false


func set_may_skip(on: bool) -> void:
	skip_label.visible = on
	may_skip = on


func _ready():
	set_may_skip(true)
	timer.start(5)
	yield(timer, "timeout")
	G.dialogue.start_dialogue("road")
	yield(G.dialogue, "finished")
	
	#переход на следующую сцену
	timer.start(4)
	yield(timer, "timeout")
	G.goto_scene(NEXT_LEVEL)


func _process(_delta: float) -> void:
	if may_skip:
		if Input.is_action_just_pressed("ui_flashlight"):
			G.goto_scene(NEXT_LEVEL)
