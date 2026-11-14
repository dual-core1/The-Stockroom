class_name Transition extends Control

@export var anim: AnimationPlayer

var already_closed = false

func _ready():
	show()

func open():
	anim.play("open")

func close():
	anim.play("close")
	already_closed = true
