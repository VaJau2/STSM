extends Control

#--------------------------------
# Меню инвентаря, отвечает за анимацию всплытия
# и за взаимодействия игрока с инвентарем
#--------------------------------

onready var anim = get_node("anim")
onready var back = get_node("back")
onready var item_header = get_node("back/back2/ItemHeader")
onready var item_desc = get_node("back/back2/ItemDesc")

export var player_path: NodePath

var player = null
var active_item_prefab = null
var hidden: bool = true
var may_change: bool = true
var items_data: Dictionary



func get_items_data() -> void:
	if items_data.empty(): items_data = G.parse_json_data("items")


func get_item_data(item_code: String) -> Dictionary:
	get_items_data()
	assert(items_data.has(item_code), "there is no data for item " + item_code)
	return items_data[item_code]


func select_item(item_data: Dictionary) -> void:
	var player_item = player.get_node("item")
	
	if active_item_prefab != null:
		active_item_prefab.destroy()
		active_item_prefab = null
	
	if item_data == null || item_data.empty():
		player_item.texture = null
		return
	
	if item_data.has("texture"):
		var texture = load("res://assets/sprites/items/" + item_data.texture + ".png")
		player_item.texture = texture
	if item_data.has("prefab"):
		var prefab = load("res://objects/item_prefabs/" + item_data.prefab + ".tscn")
		active_item_prefab = prefab.instance()
		player_item.add_child(active_item_prefab)


func hide_item_data() -> void:
	item_header.text = ""
	item_desc.text = ""


func show_item_data(item_code: String) -> void:
	var item_data = get_item_data(item_code)
	item_header.text = item_data.name
	item_desc.text = item_data.desc


func set_hidden(make_hidden: bool) -> void:
	hidden = make_hidden
	if !make_hidden: 
		back.visible = true
	var new_anim = "hide" if hidden else "show"
	anim.current_animation = new_anim
	if make_hidden:
		may_change = false
		yield(anim, "animation_finished")
		back.visible = false
		may_change = true


func _ready() -> void:
	player = get_node(player_path)
	anim.current_animation = "hide"


func _process(_delta: float) -> void:
	if (may_change && Input.is_action_just_pressed("ui_inventory")):
		set_hidden(!hidden)
