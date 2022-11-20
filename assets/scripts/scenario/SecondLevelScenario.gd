extends Node


func _ready():
	yield(get_tree().create_timer(5), "timeout")
	G.dialogue.start_dialogue("road")
	yield(G.dialogue, "finished")
	
	#переход на следующую сцену
	yield(get_tree().create_timer(4), "timeout")
	G.goto_scene("Base")
