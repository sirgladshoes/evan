extends Node2D


var target: Node2D = null

signal mined_resource(type)

func _physics_process(delta):
	
	var result = shoot_ray(100*Vector2(cos(global_rotation), -sin(global_rotation)))
	if result:
		global_rotation = (result.pos-global_position).angle()
		$line.visible = true
		var distance = (result.pos-global_position).length()
		$line.set_point_position(1, Vector2(distance, 0))



func shoot_ray(target_: Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_)
	query.collision_mask = 4
	var result = space_state.intersect_ray(query)
	if result:
		return {"obj": result.collider, "pos": result.position}
	return null



func _on_mining_timer_timeout():
	mined_resource.emit("gold")
