class_name Lexer

const LETTER_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const NUMERIC_CHARS = "0123456789"
const KEYWORDS = ["do", "times", "not"]

var expression : String
var split_expr : Array
var position : Position
var current_char : String
var errors := []

func _init(expression : String):
	self.expression = expression
	split_expr = expression.split("\n")
	if split_expr.size() > 0:
		self.position = Position.new(-1, -1, 1, split_expr[0])
	else:
		self.position = Position.new(-1, -1, 1)
	self.current_char = ""
	advance()

func lex() -> Array:
	var tokens := []
	var token := get_next_token()
	while token.type != Token.Type.EOF:
		tokens.append(token)
		token = get_next_token()
	tokens.append(token)
	return tokens

func advance():
	position.advance(current_char, split_expr)
	if position.index < len(expression):
		current_char = expression[position.index]
	else:
		current_char = ""

func get_next_token() -> Token:
	while position.index < len(expression):
		match current_char:
			"+":
				advance()
				return Token.new(Token.Type.PLUS, position.duplicate())
			"-":
				advance()
				return Token.new(Token.Type.MINUS, position.duplicate())
			"*":
				advance()
				return Token.new(Token.Type.MUL, position.duplicate())
			"/":
				advance()
				return Token.new(Token.Type.DIV, position.duplicate())
			"=":
				advance()
				return get_comparison(Token.Type.EQ)
			"\"":
				advance()
				return get_string_token()
			",":
				advance()
				return Token.new(Token.Type.COMMA, position.duplicate())
			"{":
				advance()
				return Token.new(Token.Type.LCURLY, position.duplicate())
			"}":
				advance()
				return Token.new(Token.Type.RCURLY, position.duplicate())
			"(":
				advance()
				return Token.new(Token.Type.LPAREN, position.duplicate())
			")":
				advance()
				return Token.new(Token.Type.RPAREN, position.duplicate())
			"<":
				advance()
				return get_comparison(Token.Type.LSR)
			">":
				advance()
				return get_comparison(Token.Type.GRT)
			"\n":
				advance()
				return Token.new(Token.Type.NEWLINE, position.duplicate())
			" ", "\t":
				pass
			_:
				if is_alphabetic(current_char) or current_char == "_":
					return get_identifier_token()
				elif is_numeric(current_char):
					return get_number_token()
				errors.append(Error.new("InvalidCharacterError", "Unknown character \"%s\"" % current_char, position.duplicate()))
		advance()
	return Token.new(Token.Type.EOF, position)

func is_alphabetic(string : String) -> bool:
	return string in LETTER_CHARS

func is_numeric(string : String) -> bool:
	return string in NUMERIC_CHARS

func get_comparison(token_type : int) -> Token:
	var start_pos := position.duplicate()
	if (current_char == "="):
		advance()
		match token_type:
			Token.Type.LSR:
				token_type = Token.Type.LSE
			Token.Type.GRT:
				token_type = Token.Type.GRE
			Token.Type.EQ:
				token_type = Token.Type.ISEQ
	return Token.new(token_type, start_pos)

func get_identifier_token() -> Token:
	var identifier := ""
	var token_type : int
	var start_pos := position.duplicate()
	while is_alphabetic(current_char) or is_numeric(current_char) or current_char == "_":
		identifier += current_char
		advance()
	if identifier in KEYWORDS:
		token_type = Token.Type.KEYWORD
	else:
		token_type = Token.Type.IDENTIFIER
	return Token.new(token_type, start_pos, identifier)

func get_number_token() -> Token:
	var number := ""
	var number_of_dots := 0
	var token_type : int
	var start_pos := position.duplicate()
	while is_numeric(current_char) or (number_of_dots == 0 and current_char == "."):
		number += current_char
		if (current_char == "."):
			number_of_dots += 1
		advance()
	if (number_of_dots > 0):
		token_type = Token.Type.FLOAT
	else:
		token_type = Token.Type.INT
	return Token.new(token_type, start_pos, number)

func get_string_token() -> Token:
	var string := ""
	var start_pos := position.duplicate()
	while current_char != "\"":
		if current_char == "":
			return Token.new(Token.Type.EOF, position)
		string += current_char
		advance()
	advance()
	return Token.new(Token.Type.STRING, start_pos, string)
