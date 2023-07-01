extends CharacterBody2D
class_name Weapon

var attack_power_stat : float = 5
var speed_stat : float = 50
var control_stat : float = 50
var max_battery_stat : float = 100

var speed : float
var control : float
var battery : float

enum State {HELD, HACK, RETURNING}
var state : State = State.HELD
var attack_state := 0
var moving := false

var move_target : Vector2
var owner_entity : Entity
var animator : AnimationTree

func _ready() -> void:
	$Hitbox.connect("body_entered", _on_body_entered)
	speed = speed_stat * 10
	control = control_stat / 500
	battery = max_battery_stat

func _process(delta) -> void:
	if state == State.RETURNING: return
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("hack_attack"):
		handle_hack_attack()

func _physics_process(delta) -> void:
	if state == State.RETURNING:
		return_to_owner(delta)
	elif moving == true:
		handle_movement(delta)
	move_and_slide()
	velocity -= velocity * control

func attack() -> void:
	match state:
		State.HELD:
			swing()
		State.HACK:
			hack_attack()

func handle_movement(delta : float) -> void:
	if global_position.distance_to(move_target) < velocity.length() * delta:
		moving = false
	else:
		var rotation_angle = global_position.angle_to_point(move_target) + deg_to_rad(135)
		rotation = lerp_angle(rotation, rotation_angle, delta * control_stat / 10)
		var forward = global_transform.y.rotated(deg_to_rad(135))
		if global_position.direction_to(move_target).dot(forward) > 0.9999:
			velocity = forward * speed

func return_to_owner(delta : float) -> void:
	if global_position.distance_to(owner_entity.global_position) < velocity.length() * delta:
		get_parent().remove_child(self)
		owner_entity.get_node("%WeaponGrip").add_child(self)
		rotation = 0
		position = Vector2.ZERO
		velocity = Vector2.ZERO
		state = State.HELD
		toggle_hitbox(false)
		return
	var direction = owner_entity.global_position - global_position
	velocity = direction.normalized() * speed
	rotation += 40 * delta

func handle_hack_attack() -> void:
	match state:
		State.HELD:
			initialize_hack_attack()
		State.HACK:
			stop_hack_attack()

func initialize_hack_attack() -> void:
	var root = get_tree().current_scene
	var current_pos = global_position
	get_parent().remove_child(self)
	root.add_child(self)
	global_position = current_pos
	animator["parameters/conditions/swinging"] = false
	animator["parameters/conditions/swinging2"] = false
	animator["parameters/conditions/reset"] = true
	attack_state = 0
	state = State.HACK
	toggle_hitbox(true)

func stop_hack_attack() -> void:
	state = State.RETURNING
	moving = false

func toggle_hitbox(value : bool) -> void:
	$Hitbox.monitoring = value

func move(x : float, y : float) -> void:
	move_target = Vector2(x, y)
	moving = true

func swing() -> void:
	match attack_state:
		0:
			animator["parameters/conditions/reset"] = false
			animator["parameters/conditions/swinging2"] = false
			animator["parameters/conditions/swinging"] = true
			attack_state = 1
		1:
			animator["parameters/conditions/swinging"] = false
			animator["parameters/conditions/swinging2"] = true
			attack_state = 0

func hack_attack() -> void:
	pass

func _on_body_entered(body) -> void:
	if body == owner_entity: return
	var damager = owner_entity if state == State.HELD else self
	if body.has_method("take_damage"):
		body.take_damage(attack_power_stat, damager)
