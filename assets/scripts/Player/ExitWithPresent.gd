extends Node2D

export var new_scene_name: String = "Town"

onready var audi: AudioStreamPlayer2D = get_node_or_null("audi")

var may_interact: bool setget ,get_may_interact


func get_may_interact() -> bool:
	return G.player.has_present


func interact(_player) -> void:
	if audi != null: audi.play()
	G.player.save_to_global()
	G.goto_scene(new_scene_name)
