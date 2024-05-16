extends CharacterBody2D

func _physics_process(delta):
	move_and_slide()
	

func _on_collider_body_entered(body):
	if "velocity" in body:
		velocity = body.velocity + velocity
		body.velocity = Vector2(0,0)
	else:
		velocity = velocity / -2
	pass # Replace with function body.
