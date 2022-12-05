extends WalkingPony

#--------------------------------
# Класс персонажей, бегающих на фоне по рандомным точкам
#--------------------------------

const DEFAULT_IDLE_ANIM = "idle"
const MIN_IDLE = 4
const MAX_IDLE = 10
const WALK_CHANCE = 0.5


export (Array, NodePath) var random_points_path
export var idle_animations: PoolStringArray
export var dialogue_codes: PoolStringArray
export var minimap_icon: String = "animal"

var may_interact: bool setget , is_may_interact
var random_points: Array
var idle_timer: float
var is_walking: bool = false


func _ready() -> void:
	for point_path in random_points_path:
		random_points.append(get_node(point_path))
	get_new_state()


func set_is_stunned(value: bool) -> void:
	.set_is_stunned(value)
	change_animation("idle")


func _process(delta: float) -> void:
	._process(delta)
	if is_stunned: return
	if has_target: return
	elif idle_timer > 0:
		idle_timer -= delta
	else:
		get_new_state()


func get_new_state() -> void:
	if randf() > WALK_CHANCE:
		get_random_walk_dir()
		return
	
	change_animation(get_random_idle_animation())
	idle_timer = rand_range(MIN_IDLE, MAX_IDLE)


func is_may_interact() -> bool:
	return !dialogue_codes.empty()


func interact(_interactor) -> void:
	may_move = false
	var rand_code = rand_range(0, dialogue_codes.size())
	G.dialogue.start_dialogue(dialogue_codes[rand_code])
	yield(G.dialogue, "finished")
	may_move = true


func change_animation(new_animation: String) -> void:
	if anim.current_animation != new_animation:
		anim.current_animation = new_animation


func look_at_direction(direction: Vector2) -> void:
	set_flip_x(direction.x < 0)


func get_random_idle_animation() -> String:
	if idle_animations.size() == 0:
		return DEFAULT_IDLE_ANIM
	var randI = randi() % idle_animations.size()
	return idle_animations[randI]


func get_random_walk_dir() -> void:
	if random_points.size() == 0:
		return
	var randI = randi() % random_points.size()
	var point = random_points[randI].position
	set_target(point)
