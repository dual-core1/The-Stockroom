class_name GameOver extends Control

func set_text(val: String):
	var title: Label = get_node("title")
	title.text = val
