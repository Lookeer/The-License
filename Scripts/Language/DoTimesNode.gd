class_name DoTimesNode

var instructions_node : InstructionsNode
var times_node

func _init(instructions_node : InstructionsNode, times_node) -> void:
	self.instructions_node = instructions_node
	self.times_node = times_node

func get_node_type() -> String:
	return "DoTimesNode"
