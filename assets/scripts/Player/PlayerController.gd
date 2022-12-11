extends Character

#--------------------------------
# Отвечает за передвижения игрока
#--------------------------------

export var speed = 120
export var run_speed = 200
export var crouch_speed = 60
export var acceleration = 800
export var default_land_material = "snow"
export var present_path: NodePath
export var set_grenades_count: int = -1

var dir = Vector2()
var tied = false
var is_in_dialogue = false

onready var interaction = get_node("interaction")
onready var states: PlayerStates = get_node("states")
onready var grenade_effects = get_node_or_null("/root/Scene/Canvas/AfterGrenade")
onready var pickable_item = get_node("pickableItem")

var has_item: bool = false
var has_present: bool = false

#warning-ignore:unused_signal
signal drop_item


func pickup_item(item_type: String, item = null) -> void:
	states.clean()
	pickable_item.set_on(item_type, item)
	has_item = true


func play_tie_sound() -> void:
	$items.stream = load("res://assets/audio/items/lasso_tie.wav")
	$items.play()


func tie() -> void:
	states.set_tied()
	tied = true
	play_tie_sound()
	yield(get_tree().create_timer(2), "timeout")
	G.goto_scene("Lose")


func stun():
	if grenade_effects == null: return
	if !tied: states.set_stunned(true)
	grenade_effects.show()
	yield(grenade_effects, "done")
	if tied: return
	states.set_stunned(false)


func is_running() -> bool:
	return states.is_running()


func is_crouching() -> bool:
	return states.is_crouching()


func update_keys() -> void:
	dir = Vector2.ZERO
	may_move = states.may_move()
	if is_in_dialogue: return
	
	if states.may_move():
		if Input.is_action_pressed("ui_up"):
			dir.y = -1
		elif Input.is_action_pressed("ui_down"):
			dir.y = 1
		
		if Input.is_action_pressed("ui_left"):
			dir.x = -1
			set_flip_x(true)
		elif Input.is_action_pressed("ui_right"):
			dir.x = 1
			set_flip_x(false)
		
		var shift_is_pressed = Input.is_action_pressed("ui_shift")
		states.set_running(shift_is_pressed)
		
		if Input.is_action_just_pressed("ui_crouch"):
			states.toggle_crouching()


func update_velocity(delta: float) -> void:
	var target_speed = get_current_speed()
	velocity = velocity.move_toward(dir * target_speed, acceleration * delta)
	change_animation(get_current_animation())


func get_current_speed() -> int:
	var state = states.moving_states
	
	match states.moving_state:
		state.crouching: return crouch_speed
		state.running: return run_speed
		state.walking: return speed
		_: return 0


func get_current_animation() -> String:
	var state = states.moving_states
	var is_moving = dir.length() > 0
	
	match states.moving_state:
		state.stunned: return "stunned"
		state.tied: return "tied"
		state.crouching: return "crouch" if is_moving else "crouch-idle"
		state.running: return "run" if is_moving else "idle"
		state.walking: return "walk" if is_moving else "idle"
		_: return "idle"


func set_flip_x(flip_on: bool) -> void:
	.set_flip_x(flip_on)
	if flip_x:
		interaction.scale.x = interaction.scale.y * -1
	else:
		interaction.scale.x = interaction.scale.y * 1


func _ready() -> void:
	if set_grenades_count >= 0:
		G.grenades_count = set_grenades_count
	$soundSteps.land_material = default_land_material
	G.player = self
	if !present_path.is_empty():
		var present = get_node(present_path)
		pickup_item("present", present)


func _process(delta) -> void:
	update_keys()
	update_velocity(delta)
