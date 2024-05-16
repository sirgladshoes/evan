extends Area2D
var velocity = Vector2(0,0)
var speed = 50
var team

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(cos(rotation), sin(rotation)) * speed
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity
	pass


func _on_body_entered(body):
	if body is unit and body.team != team:
		body.take_damage(1)
		queue_free()
	pass # Replace with function body.
