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

var minimap_icon: String = "enemy"

enum states {idle, search, attack}
var state = states.idle

var patrol_points: Array
var pointI: int
var wait_timer: float
var update_timer: float

var may_interact: bool setget ,get_may_interact
var is_tied: bool = false


func get_may_interact() -> bool:
	if !is_stunned: return false
	if is_tied:
		return !G.player.has_item && !G.player.tied
	return true


func untie() -> void:
	is_tied = false
	may_move = true


func interact(player) -> void:
	if is_tied:
		player.pickup_item("guard", self)
	else:
		change_animation("tied")
		player.play_tie_sound()
		is_tied = true


func player_is_tied() -> bool:
	if G.player == null: return false
	return G.player.tied


func set_is_stunned(value: bool) -> void:
	if is_tied: return
	.set_is_stunned(value)
	var new_anim = "stunned" if value else "idle"
	change_animation(new_anim)


func set_state(new_state: int) -> void:
	match new_state:
		states.idle:
			lasso_handler.set_item_on(false)
			set_patrol_target()
		states.search:
			var last_see_pos = seek_area.victim_position
			set_target(last_see_pos)
			wait_timer = rand_range(SEARCH_WAIT_TIME.MIN, SEARCH_WAIT_TIME.MAX)
		states.attack:
			lasso_handler.set_item_on(true)
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


func has_tied_ally() -> bool:
	if seek_area.tied_allies.size() > 0:
		var temp_ally = seek_area.tied_allies[0]
		if !temp_ally.is_tied: 
			seek_area.tied_allies.remove(0)
		else:
			set_target(temp_ally.global_position)
		return true
	return false


func update_search(delta: float) -> void:
	if has_target: return
	if wait_timer > 0:
		wait_timer -= delta
	else:
		set_state(states.idle)


func update_attack(delta: float) -> void:
	update_victim_pos(delta)


func update_victim_pos(delta: float) -> void:
	if update_timer > 0:
		update_timer -= delta
	else:
		set_target(seek_area.victim_position)
		update_timer = UPDATE_POS_TIME


func update_walk_velocity(dir: Vector2) -> void:
	if state == states.attack:
		var player_pos = seek_area.victim_position
		var distance = global_position.distance_to(player_pos)
		if distance >= RUN_DISTANCE:
			velocity = dir * run_speed
			change_animation("run")
			return
	.update_walk_velocity(dir)


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
	body.untie()
