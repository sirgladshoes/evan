extends Node2D

var select_origin = null
@export var selection_mask = 1

#@onready var UI: CanvasLayer = get_node("Ui")

var selected_units = []

signal show_toolbar()
signal hide_toolbar()
signal update_toolbar(data)

func _process(delta):
	for unit in selected_units:
		if unit == null:
			selected_units.erase(unit)
	if Input.is_action_just_pressed("select"):
		if !(selected_units and get_viewport().get_mouse_position().y <= get_viewport_rect().size.y * 8/72): 
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
	
	if selected_units:
		push_toolbar()

func begin_select():
	visible = true
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
		show_toolbar.emit()
	else:
		hide_toolbar.emit()

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



func push_toolbar():
	var data = {}
	var currency = {"gnome_flesh" : 0, "gold" : 0, "credits" : 0}
	data["currency"] = currency
	data["modes"] = {"sentry":"", "mining":""}
	var sentry_count = 0
	var mining_count = 0
	for unit in selected_units:
		currency["gnome_flesh"] += unit.inventory.gnome_flesh
		currency["gold"] += unit.inventory.gold
		currency["credits"] += unit.inventory.credits
		if unit is controllable_unit :
			if unit.mode == controllable_unit.behaviour.SENTRY:
				sentry_count += 1
			if unit.mode == controllable_unit.behaviour.MINING:
				mining_count += 1
	
	if sentry_count == selected_units.size():
		data.modes.sentry = "all"
	elif sentry_count == 0:
		data.modes.sentry = "none"
	else:
		data.modes.sentry = "some"
	
	if mining_count == selected_units.size():
		data.modes.mining = "all"
	elif mining_count == 0:
		data.modes.mining = "none"
	else:
		data.modes.mining = "some"
	
	data["ship_count"] = selected_units.size()
	
	update_toolbar.emit(data)


func _on_ui_set_mining():
	for unit in selected_units:
		if unit is controllable_unit:
			unit.set_mode(controllable_unit.behaviour.MINING)


func _on_ui_set_sentry():
	for unit in selected_units:
		if unit is controllable_unit:
			unit.set_mode(controllable_unit.behaviour.SENTRY)


func _on_ui_disable_mining():
	for unit in selected_units:
		if unit is controllable_unit and unit.mode == controllable_unit.behaviour.MINING:
			unit.set_mode(controllable_unit.behaviour.NORMAL)


func _on_ui_disable_sentries():
	for unit in selected_units:
		if unit is controllable_unit and unit.mode == controllable_unit.behaviour.SENTRY:
			unit.set_mode(controllable_unit.behaviour.NORMAL)
