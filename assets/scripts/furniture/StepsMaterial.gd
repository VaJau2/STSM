extends Area2D

#-----
# Обрабатывает через стандартные методы попадание Character
# Меняет в их SoundSteps материал для озвучивания ходьбы
#-----

export var material_code: String
export var default_material = "snow"


func _on_body_entered(body):
	if body is Character:
		body.set_land_material(material_code)


func _on_body_exited(body):
	if body is Character:
		body.set_land_material(default_material)
