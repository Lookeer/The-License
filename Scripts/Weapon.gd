extends CharacterBody2D
class_name Weapon

var damage : float = 5
var speed : float = 50
var control : float = 200
var max_battery : float = 100

var battery : float

var held := true
var moving := false
var move_target : Vector2
var owner_entity : Entity

func _ready():
	$Hitbox.connect("body_entered", _on_body_entered)
	battery = max_battery

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(delta):
	if moving:
		if global_position.distance_to(move_target) < velocity.length() * delta:
			moving = false
		else:
			var rotation_angle = global_position.angle_to_point(move_target) + deg_to_rad(135)
			rotation = lerp_angle(rotation, rotation_angle, delta * control / 10)
			var forward = global_transform.y.rotated(deg_to_rad(135))
			if global_position.direction_to(move_target).dot(forward) > 0.9999:
				velocity = forward * speed * 10
	move_and_slide()
	velocity -= velocity * control / 1000

func attack() -> void:
	pass

func toggle_hitbox(value : bool) -> void:
	$Hitbox.monitoring = value

func move(x : float, y : float) -> void:
	move_target = Vector2(x, y)
	moving = true

func swing() -> void:
	pass

func _on_body_entered(body) -> void:
	if body == owner_entity: return
	if body.has_method("take_damage"):
		body.take_damage(damage, self)
