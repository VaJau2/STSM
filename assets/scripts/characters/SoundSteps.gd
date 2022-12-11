extends AudioStreamPlayer2D

#-----
# Озучивает шаги для всех Character
#-----

const STEP_COOLDOWN = 0.5
const STEP_RUN_COOLDOWN = 0.55

const STEP_SOUNDS_COUNT = 3

const NORMAL_VOLUME = -4.0
const CROUCH_VOLUME = -14.0

var timer = 0
var stepI = 0
var is_crouching = false

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


func get_volume() -> float:
	return CROUCH_VOLUME if parent.is_crouching() else NORMAL_VOLUME


func set_land_material(new_material: String) -> void:
	if new_material.empty(): return
	land_material = new_material


func _process(delta: float) -> void:
	if parent.velocity.length() > 0:
		if timer > 0:
			timer -= delta
		else:
			volume_db = get_volume()
			
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
