extends Node2D
@export var health = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += 100 * delta
	if health == 0:
		queue_free()
	pass


func _on_area_2d_body_entered(body):
	#body.takeDamage()
	pass # Replace with function body.


func _on_hit_box_area_entered(area):
	health -= 1
	print(health)
	print(area)
	pass # Replace with function body.
