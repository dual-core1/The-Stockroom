class_name Transition extends Control

@export var anim: AnimationPlayer

var already_closed = false
var ready_to_go = false

func _ready():
	show()

func open():
	anim.play("open")

func close():
	anim.play("close")
	already_closed = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close":
		ready_to_go = true
