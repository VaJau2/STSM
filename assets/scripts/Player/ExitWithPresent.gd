extends Node2D

#--------------------------------
# Скрипт выхода из локации
# отменяет выход, если игрока вяжут
#--------------------------------


export var new_scene_name: String = "Town"

onready var audi: AudioStreamPlayer2D = get_node_or_null("audi")
onready var background = get_node("/root/Scene/Canvas/background")

var may_interact: bool setget ,get_may_interact


func get_may_interact() -> bool:
	return G.player.has_present


func interact(_player) -> void:
	if audi != null: audi.play()
	G.player.save_to_global()
	background.animate_exit(new_scene_name)


func _on_Player_is_tied():
	background.cancel_exit()
