extends StaticBody2D

#--------------------------------
# Груз, лежащий на земле и подбираемый игроком
#--------------------------------

var may_interact: bool = true
var minimap_icon = "mission"


func spawn_marker() -> void:
	var minimap = get_node("/root/Scene/Canvas/MiniMap")
	minimap.spawn_marker(self)


func interact(player) -> void:
	player.pickup_present()
	queue_free()
