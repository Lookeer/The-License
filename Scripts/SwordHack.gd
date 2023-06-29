extends Node

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var lexer : Lexer = Lexer.new(%CodeEdit.text)
		print(lexer.lex())
