extends StaticBody2D

#--------------------------------
# Груз, лежащий на земле и подбираемый игроком
#--------------------------------

var may_interact: bool setget ,get_may_interact
var minimap_icon = "mission"
var interactable: bool = true


func get_may_interact() -> bool:
	return interactable && !G.player.has_item


func spawn_marker() -> void:
	var minimap = get_node("/root/Scene/Canvas/MiniMap")
	minimap.spawn_marker(self)


func interact(player) -> void:
	player.pickup_item("present", self)
