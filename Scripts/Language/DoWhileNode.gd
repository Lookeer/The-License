class_name DoWhileNode

var instructions_node : InstructionsNode
var condition

func _init(instructions_node : InstructionsNode, condition) -> void:
	self.instructions_node = instructions_node
	self.condition = condition

func get_node_type() -> String:
	return "DoWhileNode"
