extends Node2D

@export var anim: AnimationPlayer
@export var line: Label
@export var display: TextureRect
@export var portraits: Array[Texture2D] = [null, null]

enum {
	TYPING,
	WAITING
}

var go: bool = false
var state = TYPING
var current_line: int = 0
var chars_displayed: int = 0

var dialogue: Array[String] = [
	"OMGGGG hurry up and come online!",
	"What do you want?",
	"Our friendship could be in danger... my mom doesn't like you.",
	"Seriously? What could she possibly not like about me?",
	"She said you're a bad influence on me because you're a super\nsenior. \
	Also, you're unemployed.",
	"The hell? You're unemployed too!",
	"Yeah, because I spend so much time studying to avoid ending up\nlike you.",
	"Alright, fine. I'll get a job... but I'll do it my way."
]

var character: Array[int] = [
	0,
	1,
	0,
	1,
	0,
	1,
	0,
	1
]

func _ready():
	anim.play("fade in")

func _input(event: InputEvent) -> void:
	if event is InputEventKey \
	and event.pressed \
	and not event.echo \
	and go:
		state = TYPING
		current_line += 1
		chars_displayed = 0
		if current_line > 7:
			go = false
			anim.play("fade out")

func _process(_delta: float):
	if go:
		if state == TYPING:
			chars_displayed += 1
			if current_line <= 7:
				display.texture = portraits[character[current_line]]
				line.text = dialogue[current_line].substr(0, chars_displayed)
				if chars_displayed == dialogue[current_line].length():
					state = WAITING

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade in":
		go = true
	elif anim_name == "fade out":
		get_tree().change_scene_to_file("res://scenes/gameplay.tscn")
