class_name VariableAssignNode

var name_token : Token
var value_node

func _init(name_token : Token, value_node) -> void:
	self.name_token = name_token
	self.value_node = value_node

func _to_string() -> String:
	return "%s = %s" % [name_token.value, value_node]

func get_node_type() -> String:
	return "VariableAssignNode"
