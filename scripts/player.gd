class_name Player extends Node2D

@export var alyssa: AnimatedSprite2D
@export var anim_player: AnimationPlayer

var anim_finished: bool = true

func _ready() -> void:
	alyssa.play("default")
	anim_player.animation_finished.connect(_on_anim_finished)

func wipeout():
	alyssa.play("wipeout")
	anim_player.play("wipeout")

func _process(delta: float) -> void:
	if not Values.game_over:
		if Input.is_action_just_pressed("DODGE") and anim_finished:
			anim_player.play("dodge")
			Values.player_dodging = true

func _on_anim_finished(anim_name: String):
	anim_finished = true
	if anim_name == "dodge":
		Values.player_dodging = false
