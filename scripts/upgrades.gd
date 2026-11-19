# This is when I found the $ syntax.
extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = $CanvasLayer/continue

var avoid_retrigger: bool = false

func _ready():
	anim.play("reveal")

func _on_continue_pressed() -> void:
	if not avoid_retrigger:
		avoid_retrigger = true
		anim.play("conceal")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "conceal":
		get_tree().change_scene_to_file("res://scenes/gameplay.tscn")
