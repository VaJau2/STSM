extends Area2D

#-----
# Делает дома полупрозрачными, когда игрок позади них
#-----

const ALPHA = 0.6

export var sprite_path: NodePath
var sprite: Sprite


func _ready():
	sprite = get_node(sprite_path)


func _on_opacityArea_body_entered(body):
	if body.name == "Player":
		sprite.modulate.a = ALPHA


func _on_opacityArea_body_exited(body):
	if body.name == "Player":
		sprite.modulate.a = 1.0
