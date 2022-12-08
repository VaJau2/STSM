extends Node2D


var may_interact: bool setget ,get_may_interact


func get_may_interact() -> bool:
	return G.player.has_present


func interact(_player) -> void:
	G.goto_scene("Town")
