extends Entity

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var freeze_input : bool = false
var attack_state = 0

var weapon : Weapon

func _ready() -> void:
	Engine.time_scale = 1
	weapon = %WeaponGrip/Sword
	%WeaponGrip/Sword.owner_entity = self
	%WeaponGrip/Sword.animator = %WeaponAnimationTree
	$AnimationTree["parameters/Walk/WalkSpeed/scale"] = SPEED / 100.0

func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var lexer : Lexer = Lexer.new(%CodeEdit.text)
		var arr := lexer.lex()
		if lexer.errors:
			for err in lexer.errors:
				print(err)
			return
		var parser : Parser = Parser.new(arr)
		var ast = parser.parse()
		if parser.errors:
			for err in parser.errors:
				print(err)
			return
		for i in arr:
			print(i)
#		var compiler : Compiler = Compiler.new()
#		compiler.compile(ast)
#		var s := GDScript.new()
#		s.source_code = compiler.compiled_string
#		s.reload()
#		get_node("../Enemy").set_script(s)
#		get_node("../Enemy")._ready()
#		get_node("../Enemy").set_process(true)
#		get_node("../Enemy").set_physics_process(true)

func _physics_process(delta) -> void:
	if freeze_input: return
	get_input()
	rotate_to_mouse()
	move_and_slide()

func get_input() -> void:
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	var direction = Vector2(direction_x, direction_y)
	if direction:
		velocity = direction * SPEED
		$AnimationTree["parameters/conditions/idling"] = false
		$AnimationTree["parameters/conditions/walking"] = true
	else:
		velocity = Vector2.ZERO
		$AnimationTree["parameters/conditions/walking"] = false
		$AnimationTree["parameters/conditions/idling"] = true

func rotate_to_mouse() -> void:
	if get_global_mouse_position() > global_position:
		$Sprite2D.flip_h = true
		$WeaponPivot.scale.y = -1
	else:
		$Sprite2D.flip_h = false
		$WeaponPivot.scale.y = 1
	$WeaponPivot.rotation = get_global_mouse_position().angle_to_point(position)

func toggle_weapon_hitbox(value : bool) -> void:
	if !weapon: return
	weapon.toggle_hitbox(value)
