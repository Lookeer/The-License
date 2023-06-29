class_name FunctionCallNode

var name_token : Token
var parameters : Array

func _init(name_token : Token, parameters : Array) -> void:
	self.name_token = name_token
	self.parameters = parameters

func get_node_type() -> String:
	return "FunctionCallNode"
