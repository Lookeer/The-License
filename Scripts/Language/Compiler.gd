extends Node
class_name Compiler

var compiled_string := ""

func compile(node):
	match node.get_node_type():
		"ASTNode":
			return node.token.value
		"BinaryOperationNode":
			var left = compile(node.left_node)
			var right = compile(node.right_node)
			match node.operation_token.type:
				Token.Type.PLUS:
					return left + "+" + right
		"VariableAssignNode":
			var value = compile(node.value_node)
			compiled_string += "var " + node.name_token.value + "=" + value + "\n"
		"FunctionCallNode":
			var parameters := []
			var params_string := ""
			for p in node.parameters:
				var param = compile(p)
				parameters.append(param)
			for i in range(0, parameters.size()):
				if i == 0:
					params_string += parameters[i]
					continue
				params_string += ", " + parameters[i]
			return node.name_token.value + "(" + params_string + ")"
		"InstructionsNode":
			for i in node.instructions:
				print(i.get_node_type())
				#compile(i)
