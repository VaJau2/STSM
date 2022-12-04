extends WalkingPony

#--------------------------------
# Класс охранников
# Патрулируют, ищут и преследуют игрока в зависимости от состояния
#--------------------------------


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

onready var seek_area = get_node("seekArea")

var minimap_icon: String = "enemy"

enum states {idle, search, attack}
var state = states.idle

var patrol_points: Array
var pointI: int
var wait_timer: float
var update_timer: float


func set_state(new_state: int) -> void:
	match new_state:
		states.idle:
			set_patrol_target()
		states.search:
			var last_see_pos = seek_area.player_position
			set_target(last_see_pos)
			wait_timer = rand_range(SEARCH_WAIT_TIME.MIN, SEARCH_WAIT_TIME.MAX)
		states.attack:
			pass
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
	if patrol_points.size() == 0: return
	if has_target: return
	if wait_timer > 0:
		wait_timer -= delta
	else:
		set_patrol_target()


func update_search(delta: float) -> void:
	if has_target: return
	if wait_timer > 0:
		wait_timer -= delta
	else:
		set_state(states.idle)


func update_attack(delta: float) -> void:
	update_player_pos(delta)


func update_player_pos(delta: float) -> void:
	if update_timer > 0:
		update_timer -= delta
	else:
		set_target(seek_area.player_position)
		update_timer = UPDATE_POS_TIME


func update_walk_velocity(dir: Vector2) -> void:
	if state == states.attack:
		var player_pos = seek_area.player_position
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
	._process(delta)
	match state:
		states.idle:
			update_patrol(delta)
		states.search:
			update_search(delta)
		states.attack:
			update_attack(delta)
