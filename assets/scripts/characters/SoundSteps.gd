extends AudioStreamPlayer2D

#-----
# Озучивает шаги для всех Character
#-----

const STEP_COOLDOWN = 0.5
const STEP_RUN_COOLDOWN = 0.55

const STEP_SOUNDS_COUNT = 3

var timer = 0
var stepI = 0

var land_material = "wood"
onready var parent: Character = get_parent()

export var stepsArray = {
	"snow": [],
	"wood": [],
	"dirt": [],
	"ice": []
}

export var stepsRunArray = {
	"snow": [],
	"wood": [],
	"dirt": [],
	"ice": []
}


func set_land_material(new_material: String):
	if new_material.empty(): return
	land_material = new_material
	parent.set_land_material(new_material)


func _process(delta):
	if parent.velocity.length() > 0:
		if timer > 0:
			timer -= delta
		else:
			if parent.is_running():
				stream = stepsRunArray[land_material][stepI]
				timer = STEP_RUN_COOLDOWN
			else:
				stream = stepsArray[land_material][stepI]
				timer = STEP_COOLDOWN
			play()
			
			var oldI = stepI
			stepI = randi() % stepsArray[land_material].size()
			while oldI == stepI:
				stepI = randi() % stepsArray[land_material].size()
	else:
		stop()
