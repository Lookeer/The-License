class_name Token

enum Type {KEYWORD, IDENTIFIER, INT, FLOAT, STRING, PLUS, MINUS, MUL, DIV, EQ, LSR, LSE, GRT, GRE, ISEQ, NEWLINE, COMMA, LPAREN, RPAREN, LCURLY, RCURLY, EOF}

var type : int
var value : String
var position : Position

func _init(type : int, position : Position, value = "") -> void:
	self.type = type
	self.position = position
	self.value = value

func _to_string() -> String:
	if value:
		return "[%s, %s]" % [Type.keys()[type], value]
	return "[%s]" % [Type.keys()[type]]

func equals(type : int, value : String) -> bool:
	return self.type == type and self.value == value
