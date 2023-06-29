class_name Position

var index : int
var line_index : int
var line : int
var line_text : String

func _init(index : int, line_index : int, line : int, line_text : String = "") -> void:
	self.index = index
	self.line_index = line_index
	self.line = line
	self.line_text = line_text

func advance(char : String, lines_array : Array) -> void:
	index += 1
	line_index += 1
	if (char == "\n"):
		line_text = lines_array[line]
		line += 1
		line_index = 0

func duplicate() -> Position:
	return Position.new(index, line_index, line, line_text)
