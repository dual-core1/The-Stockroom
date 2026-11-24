extends Node2D

@export var anim: AnimationPlayer

var avoid_retrigger: bool = false

func _ready() -> void:
	anim.play("slide in")

func _on_start_button_pressed() -> void:
	if not avoid_retrigger:
		avoid_retrigger = true
		anim.play("fade")

func _on_how_to_play_pressed() -> void:
	anim.play("how to play open")

func _on_click_to_close_pressed() -> void:
	anim.play("how to play close")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		get_tree().change_scene_to_file("res://scenes/computer.tscn")
