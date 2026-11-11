class_name Transition extends Control

@export var anim: AnimationPlayer

func _ready():
	show()

func open():
	anim.play("open")

func close():
	anim.play("close")
