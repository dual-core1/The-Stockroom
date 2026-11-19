# kinda wish I didn't need a whole script for this
extends Label

func _process(_delta: float) -> void:
	text = "Points: " + str(Values.points)
