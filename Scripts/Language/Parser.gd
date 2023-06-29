class_name Parser

var tokens : Array
var position : int
var current_token : Token
var errors := []

func _init(tokens : Array) -> void:
	self.tokens = tokens
	self.position = 0
	if tokens.size() > 0:
		self.current_token = tokens[position]
	else:
		self.current_token = null

func parse():
	var instructions = instructions()
	return instructions

func instructions():
	var instructions := []
	while current_token.type != Token.Type.EOF && current_token.type != Token.Type.RCURLY:
		while current_token.type == Token.Type.NEWLINE:
			advance()
		if current_token.type == Token.Type.EOF || current_token.type == Token.Type.RCURLY:
			break
		var expression = expression()
		if errors.size() > 0:
			return null
		instructions.append(expression)
		if current_token.type != Token.Type.NEWLINE && current_token.type != Token.Type.EOF:
			errors.append(Error.new("SyntaxError", "Unexpected expression \"%s\"" % current_token.position.line_text.substr(current_token.position.line_index), current_token.position, "Expected new line"))
			return null
	return InstructionsNode.new(instructions)

func expression():
	if current_token.type == Token.Type.IDENTIFIER:
		return call_or_assign()
	elif current_token.equals(Token.Type.KEYWORD, "do"):
		advance()
		return do_expr()
	return comp_expr()

func call_or_assign():
	var name_token := current_token
	advance()
	if current_token.type == Token.Type.LPAREN:
		advance()
		return func_call(name_token)
	elif current_token.type == Token.Type.EQ:
		advance()
		return var_assign(name_token)
	errors.append(Error.new("SyntaxError", "Expected \"=\" or \"(\"", current_token.position))

func func_call(name_token : Token):
	var parameters := []
	if current_token.type == Token.Type.RPAREN:
		advance()
	else:
		var arg = comp_expr()
		if errors.size() > 0:
			return null
		parameters.append(arg)
		while current_token.type == Token.Type.COMMA:
			advance()
			arg = comp_expr()
			if errors.size() > 0:
				return null
			parameters.append(arg)
		if current_token.type != Token.Type.RPAREN:
			errors.append(Error.new("SyntaxError", "Expected \")\"", current_token.position))
			return null
		advance()
	return FunctionCallNode.new(name_token, parameters)

func var_assign(name_token : Token):
	var value_node = comp_expr()
	return VariableAssignNode.new(name_token, value_node)

func do_expr():
	var node_type : String
	var condition
	var times_node
	if current_token.equals(Token.Type.KEYWORD, "while"):
		advance()
		condition = comp_expr()
		if errors.size() > 0:
			return null
		node_type = "while"
	else:
		times_node = comp_expr()
		if errors.size() > 0:
			return null
		if !current_token.equals(Token.Type.KEYWORD, "times"):
			errors.append(Error.new("SyntaxError", "Expected \"times\" keyword", current_token.position))
			return null
		advance()
		node_type = "times"
	
	if current_token.type != Token.Type.LCURLY:
		errors.append(Error.new("SyntaxError", "Expected \"{\"", current_token.position))
		return null
	advance()
	
	var instructions = instructions()
	if errors.size() > 0:
		return null
	if current_token.type != Token.Type.RCURLY:
		errors.append(Error.new("SyntaxError", "Expected \"}\"", current_token.position))
		return null
	advance()
	
	match node_type:
		"while":
			return DoWhileNode.new(instructions, condition)
		"times":
			return DoTimesNode.new(instructions, times_node)

func comp_expr():
	if current_token.equals(Token.Type.KEYWORD, "not"):
		var operation_token = current_token
		advance()
		var expr = comp_expr()
		if errors.size() > 0:
			return null
		return UnaryOperationNode.new(expr, operation_token)
	
	var node = do_operation(math_expr1, [Token.Type.LSR, Token.Type.LSE, Token.Type.GRT, Token.Type.GRE, Token.Type.ISEQ])
	if errors.size() > 0:
		return null
	return node

func math_expr1():
	return do_operation(math_expr2, [Token.Type.PLUS, Token.Type.MINUS])

func math_expr2():
	return do_operation(factor, [Token.Type.MUL, Token.Type.DIV])

func factor():
	var token = current_token
	if token.type == Token.Type.INT or token.type == Token.Type.FLOAT:
		advance()
		return ASTNode.new(token)
	elif token.type == Token.Type.LPAREN:
		advance()
		var comp_expr = comp_expr()
		if current_token.type != Token.Type.RPAREN:
			errors.append(Error.new("SyntaxError", "Expected \")\"", current_token.position))
			return null
		advance()
		return comp_expr
	elif token.type == Token.Type.IDENTIFIER:
		advance()
		if current_token.type == Token.Type.LPAREN:
			advance()
			return func_call(token)
		return VariableAccessNode.new(token)
	errors.append(Error.new("SyntaxError", "Unknown syntax", current_token.position))
	return null

func do_operation(function, operations : Array):
	var left_node = function.call()
	var right_node
	var operation_token : Token
	while current_token.type in operations:
		operation_token = current_token
		advance()
		right_node = function.call()
		left_node = BinaryOperationNode.new(left_node, right_node, operation_token)
	return left_node

func advance() -> void:
	position += 1
	current_token = tokens[position]
