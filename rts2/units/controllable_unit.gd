extends unit
class_name controllable_unit

@export var max_speed = 100
@export var thrust_speed = 100

var target_vel = Vector2.ZERO
enum behaviour {
	SENTRY, MINING, NORMAL
}
@export var mode = behaviour.NORMAL

func set_movement_dir(dir):
	target_vel = dir*max_speed

func _physics_process(delta):
	velocity = velocity.move_toward(target_vel, thrust_speed*delta)
	if velocity != target_vel:
		rotation = rotate_toward(rotation, velocity.angle(), thrust_speed/15*delta)
	move_and_slide()
	if Input.is_action_just_pressed("temp"):
		set_sentry_mode()



func set_sentry_mode():
	set_movement_dir(Vector2(0,0))
