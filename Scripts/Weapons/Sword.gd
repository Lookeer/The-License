extends Weapon

var attack_state := 0

func attack() -> void:
	move(get_global_mouse_position().x, get_global_mouse_position().y)

#func attack() -> void:
#	match attack_state:
#		0:
#			animator["parameters/conditions/swinging2"] = false
#			animator["parameters/conditions/swinging"] = true
#			attack_state += 1
#		1:
#			animator["parameters/conditions/swinging"] = false
#			animator["parameters/conditions/swinging2"] = true
#			attack_state = 0
