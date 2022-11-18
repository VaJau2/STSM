extends Node


func _ready():
	yield(get_tree().create_timer(5), "timeout")
	G.dialogue.start_dialogue("road")
