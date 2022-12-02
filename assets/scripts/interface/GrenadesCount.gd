extends Control


func grenades_count_change(count: int) -> void:
	if count > 0:
		$Label.text = str(count)
	else:
		visible = false
