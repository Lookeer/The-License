class_name Error

var type : String
var info : String
var extra_info : String
var position : Position

func _init(type : String, info : String, position : Position, extra_info : String = "") -> void:
	self.type = type
	self.info = info
	self.extra_info = extra_info
	self.position = position

func _to_string() -> String:
	return "%s: %s at line %d. %s" % [type, info, position.line, extra_info]
