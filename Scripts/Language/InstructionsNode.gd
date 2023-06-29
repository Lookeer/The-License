class_name InstructionsNode

var instructions : Array

func _init(instructions : Array):
	self.instructions = instructions

func _to_string() -> String:
	return str(instructions)

func get_node_type() -> String:
	return "InstructionsNode"
