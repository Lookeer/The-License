class_name BinaryOperationNode

var left_node
var right_node
var operation_token : Token

func _init(left_node, right_node, operation_token : Token) -> void:
	self.left_node = left_node
	self.right_node = right_node
	self.operation_token = operation_token

func _to_string() -> String:
	return "(%s %s %s)" % [left_node, Token.Type.keys()[operation_token.type], right_node]

func get_node_type() -> String:
	return "BinaryOperationNode"
