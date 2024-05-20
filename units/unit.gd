extends CharacterBody2D
class_name unit

enum teams {
	TEAM1, TEAM2
}

@export var team = teams.TEAM1
@export var health = 10
@export var mining_radius = 200

@onready var mining_laser_pckd = preload("res://components/mining_laser.tscn")

var inventory = {"gnome_flesh" : 0, "gold" : 0, "credits" : 0}

func select():
	var color = $MiniGuySelect.material.get_shader_parameter("color")
	$MiniGuySelect.material.set_shader_parameter("color", Vector3(color.x, 0, color.y))

func deselect():
	var color = $MiniGuySelect.material.get_shader_parameter("color")
	$MiniGuySelect.material.set_shader_parameter("color", Vector3(color.x, color.z, 0))

func take_damage(val):
	health -= val
	if health <= 0:
		queue_free()

func get_target():
	var query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	circle.radius = mining_radius
	query.set_shape(circle)
	query.transform = Transform2D(0, global_position)
	query.collision_mask = 4
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)
	
	if !result:
		return null
	return result[0]["collider"]

func mined_resource(type):
	inventory[type] = inventory[type]+1
