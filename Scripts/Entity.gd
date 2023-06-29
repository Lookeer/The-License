extends CharacterBody2D
class_name Entity

var health := 100

func take_damage(damage : int, source) -> void:
	var direction = (global_position - source.global_position).normalized()
	health -= damage
	velocity += direction * 100
	if health <= 0:
		queue_free()
