extends Entity
class_name Enemy

func _physics_process(delta):
	move_and_slide()
	if velocity.length() > 0:
		velocity = lerp(velocity, Vector2.ZERO, delta * 4)
