extends WalkingPony

#--------------------------------
# Класс охранников
# Патрулируют, ищут и преследуют игрока в зависимости от состояния
#--------------------------------

class_name Guard

const PATROL_WAIT_TIME = {
	"MIN": 2,
	"MAX": 4
}
const SEARCH_WAIT_TIME = {
	"MIN": 3,
	"MAX": 5
}
const UPDATE_POS_TIME = 1
const RUN_DISTANCE = 80

export(Array, NodePath) var patrol_points_path
export var default_land_material = "snow"
export var run_speed = 150

onready var lasso_handler = get_node("lassoHandler")
onready var seek_area = get_node("seekArea")
onready var phrases = get_node("phrase")

var minimap_icon: String = "enemy"

enum states {idle, search, attack}
var state = states.idle

var patrol_points: Array
var pointI: int
var wait_timer: float
var update_timer: float

var may_interact: bool setget ,get_may_interact
var is_tied: bool = false


func set_search_position(search_position: Vector2) -> void:
	if state == states.attack: return
	seek_area.last_see_position = search_position
	set_state(states.search)


func get_may_interact() -> bool:
	if !is_stunned && state != states.idle: 
		return false
	if is_tied:
		return !G.player.has_item && !G.player.tied
	return true


func untie() -> void:
	is_tied = false
	may_move = true
	phrases.say("untied", 0.8)


func interact(player) -> void:
	if is_tied:
		player.pickup_item("guard", self)
	else:
		phrases.say("fail", 0.7)
		set_is_stunned(true)
		change_animation("tied")
		player.play_tie_sound()
		is_tied = true


func drop() -> void:
	phrases.say("drop", 0.6)


func player_is_tied() -> bool:
	if G.player == null: return false
	return G.player.tied


func set_is_stunned(value: bool) -> void:
	if is_tied: return
	.set_is_stunned(value)
	var new_anim = "stunned" if value else "idle"
	change_animation(new_anim)
	if value:
		phrases.say("stun", 0.4)


func set_state(new_state: int) -> void:
	if state == new_state: return
	match new_state:
		states.idle:
			lasso_handler.set_item_on(false)
			set_patrol_target()
			phrases.say("idle", 0.2)
		states.search:
			var last_see_pos = seek_area.last_see_position
			set_target(last_see_pos)
			wait_timer = rand_range(SEARCH_WAIT_TIME.MIN, SEARCH_WAIT_TIME.MAX)
		states.attack:
			lasso_handler.set_item_on(true)
			phrases.say("attack", 0.2)
	state = new_state


func set_patrol_target() -> void:
	if patrol_points.size() == 0: return
	set_target(patrol_points[pointI].global_position)
	wait_timer = rand_range(PATROL_WAIT_TIME.MIN, PATROL_WAIT_TIME.MAX)
	if pointI < patrol_points.size() - 1:
		pointI += 1
	else:
		pointI = 0


func update_patrol(delta: float) -> void:
	if has_tied_ally(): return
	if patrol_points.size() == 0: return
	if has_target: return
	if wait_timer > 0:
		wait_timer -= delta
	else:
		set_patrol_target()
		phrases.say("patrol", 0.2)


func has_tied_ally() -> bool:
	if seek_area.tied_allies.size() > 0:
		var temp_ally = seek_area.tied_allies[0]
		if !temp_ally.is_tied: 
			seek_area.tied_allies.remove(0)
		else:
			set_target(temp_ally.global_position)
		return true
	return false


func set_flip_x(flip_on: bool) -> void:
	.set_flip_x(flip_on)
	if flip_x:
		phrases.scale.x = phrases.scale.y * -1
	else:
		phrases.scale.x = phrases.scale.y * 1



func update_search(delta: float) -> void:
	if has_target: return
	if wait_timer > 0:
		wait_timer -= delta
	else:
		set_state(states.idle)


func update_attack(delta: float) -> void:
	if update_timer > 0:
		update_timer -= delta
	else:
		set_target(seek_area.player_position)
		update_timer = UPDATE_POS_TIME


func update_velocity(dir: Vector2, delta: float) -> void:
	if state == states.attack || state == states.search:
		var distance = agent.distance_to_target()
		if distance >= RUN_DISTANCE * (1 if state == states.attack else 2):
			velocity = velocity.move_toward(dir * run_speed, acceleration * delta)
			change_animation("run")
			return
	.update_velocity(dir, delta)


func _ready() -> void:
	._ready()
	$soundSteps.land_material = default_land_material
	for point_path in patrol_points_path:
		patrol_points.append(get_node(point_path))


func _process(delta: float) -> void:
	if is_tied: return
	._process(delta)
	match state:
		states.idle:
			update_patrol(delta)
		states.search:
			update_search(delta)
		states.attack:
			update_attack(delta)


func _on_untie_area_body_entered(body):
	if is_tied: return
	if !body.has_method("untie") || !body.is_tied: return
	phrases.say("untie", 0.7)
	body.untie()
