class_name VariableAccessNode

var name_token : Token

func _init(name_token : Token) -> void:
	self.name_token = name_token

func _to_string() -> String:
	return "%s" % [name_token]

func get_node_type() -> String:
	return "VariableAccessNode"
