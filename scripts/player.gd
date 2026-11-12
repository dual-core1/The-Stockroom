class_name Player extends Node2D

@export var alyssa: AnimatedSprite2D
@export var anim_player: AnimationPlayer
@export var flip_anim: AnimationPlayer

var jumping: bool = false
var flipping: bool = false

var landed_jump: bool = false
var landed_flip: bool = false

func _ready() -> void:
	alyssa.play("default")
	anim_player.animation_finished.connect(_on_dodge_finished)

func check_successful_stunt():
	if landed_jump and landed_flip and not Values.game_over:
		landed_jump = false
		landed_flip = false
		return true
	else:
		return false

func jump():
	anim_player.play("jump")
	jumping = true

func wipeout():
	flip_anim.play("RESET")
	alyssa.play("wipeout")
	anim_player.play("wipeout")

func _process(delta: float) -> void:
	if not Values.game_over:
		if Input.is_action_just_pressed("DODGE") and not jumping and not Values.player_dodging:
			anim_player.play("dodge")
			Values.player_dodging = true
		
		if Input.is_action_just_pressed("STUNT"):
			if jumping:
				flip_anim.play("flip")
				flipping = true

# was originally only for the dodge animation...
func _on_dodge_finished(anim_name: String):
	if anim_name == "dodge":
		Values.player_dodging = false
	elif anim_name == "jump":
		jumping = false
		landed_jump = true
	
func _on_flip_animation_finished(anim_name: StringName) -> void:
	flipping = false
	landed_flip = true
