extends Weapon

func hack_attack() -> void:
	move(get_global_mouse_position().x, get_global_mouse_position().y)
