class_name UnaryOperationNode

var node
var operation_token : Token

func _init(node, operation_token : Token) -> void:
	self.node = node
	self.operation_token = operation_token

func _to_string() -> String:
	return "(%s %s)" % [Token.Type.keys()[operation_token.type], node]

func get_node_type() -> String:
	return "UnaryOperationNode"
