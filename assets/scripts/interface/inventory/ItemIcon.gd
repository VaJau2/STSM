extends ColorRect

#--------------------------------
# Иконка предмета, отвечает за взаимодействие с отдельным предметом в инвентаре
#--------------------------------

const ACITVE_COLOR = Color(0, 1, 0)
const HOVER_COLOR = Color(1, 1, 1)
const DEFAULT_COLOR = Color(0.5, 0.5, 0.5)

export var item_code: String

onready var parent = get_node("../../../../")
onready var icon = get_node("icon")

var borders: Array
var item_data: Dictionary
var active: bool


func _ready():
	for child in get_children():
		if child.name.begins_with("border"):
			borders.append(child)
	if !item_code.empty(): set_item(item_code)


func set_item(code: String) -> void:
	item_data = parent.get_item_data(code)
	item_code = code
	var texture_code = item_data.icon
	var texture = load("res://assets/sprites/icons/" + texture_code + ".png")
	icon.texture = texture


func set_active(make_active: bool) -> void:
	active = make_active
	update_borders_color()
	parent.select_item(item_data if active else {})


func update_borders_color(hover: bool = false) -> void:
	var new_color: Color
	
	if active:
		new_color = ACITVE_COLOR
	else:
		new_color = HOVER_COLOR if hover else DEFAULT_COLOR
	
	for border in borders:
		border.color = new_color


func _on_ItemIcon_mouse_entered() -> void:
	if item_code.empty(): return
	update_borders_color(true)
	parent.show_item_data(item_code)


func _on_ItemIcon_mouse_exited() -> void:
	if item_code.empty(): return
	update_borders_color(false)
	parent.hide_item_data()


func _on_ItemIcon_gui_input(event):
	if !(event is InputEventMouseButton) || !event.pressed: return
	if item_code.empty(): return
	set_active(!active)
