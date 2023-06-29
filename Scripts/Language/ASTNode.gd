class_name ASTNode

var token : Token

func _init(token : Token):
	self.token = token

func _to_string():
	return token.value

func get_node_type() -> String:
	return "ASTNode"
