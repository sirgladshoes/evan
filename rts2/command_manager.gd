extends Node2D

var select_origin = null
@export var selection_mask = 1

@onready var UI: CanvasLayer = get_node("Ui")

var selected_units = []

func _process(delta):
	visible = true
	for unit in selected_units:
		if unit == null:
			selected_units.erase(unit)
	if Input.is_action_just_pressed("select"):
		if UI.visible != true || get_viewport().get_mouse_position().y >= get_viewport_rect().size.y * 8/72: 
			begin_select()
	if Input.is_action_pressed("select"):
		if select_origin != null:
			select_tick()
	if Input.is_action_just_released("select"):
		if select_origin != null:
			select_release()
	
	if Input.is_action_pressed("move_units"):
		move_units()
	if Input.is_action_just_pressed("stop_units"):
		stop_units()

func begin_select():
	select_origin = get_global_mouse_position()

func select_tick():
	queue_redraw()

func select_release():
	var select_position = get_global_mouse_position()
	var w = select_position.x-select_origin.x
	var h = select_position.y-select_origin.y
	
	var query = PhysicsShapeQueryParameters2D.new()
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(abs(w)/2, abs(h)/2)
	query.set_shape(rect)
	query.transform = Transform2D(0, select_origin+Vector2(w,h)/2)
	query.collision_mask = selection_mask
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)
	
	
	for unit in selected_units:
		unit.deselect()
	
	selected_units = []
	for target in result:
		if target["collider"] is unit:
			selected_units.append(target["collider"])
			target["collider"].select()
	
	select_origin = null
	visible = false
	
	if selected_units.size() > 0:
		UI.visible = true
		UI.updateRender()
	else:
		UI.visible = false

func _draw():
	if select_origin:
		var select_position = get_global_mouse_position()
		var w = select_position.x-select_origin.x
		var h = select_position.y-select_origin.y
		draw_rect(Rect2(select_origin.x, select_origin.y, w, h), Color(1,1,1,1), false)


func move_units():
	
	#gets center of selected units
	var controllable_units = []
	var unit_position_sum = Vector2.ZERO
	for unit in selected_units:
		if unit is controllable_unit:
			unit_position_sum+= unit.global_position
			controllable_units.append(unit)
	var selected_center = unit_position_sum/controllable_units.size()
	
	var dir = selected_center.direction_to(get_global_mouse_position())
	for unit in controllable_units:
		unit.set_movement_dir(dir)

func stop_units():
	for unit in selected_units:
		if unit is controllable_unit:
			unit.set_movement_dir(Vector2.ZERO)
