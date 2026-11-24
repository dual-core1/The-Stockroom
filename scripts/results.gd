extends Node2D

@export var anim: AnimationPlayer
@export var dist_txt: Label
@export var score_txt: Label
@export var total_txt: Label

enum {
	WAIT_FADE_IN,
	COUNT_DISTANCE,
	COUNT_SCORE,
	WAIT_DISPLAY_TOTAL,
	COUNT_TOTAL,
	WAIT_FOR_KEY,
	WAIT_FADE_OUT
}

var state: int
var dist_display: int = 0
var score_display: int = 0
var total_display: int = 0
var avoid_retrigger: bool = false
var done: bool = false
var limit: float = 0.0 # limits counters to 5 seconds each

func _ready():
	anim.play("reveal")
	state = WAIT_FADE_IN
	# The calculation is run before all the ceremony
	Values.points += Values.distance + Values.run_score

func _process(delta: float):
	if not done:
		limit += delta
		if state == COUNT_DISTANCE:
			
			if limit >= 5.0:
				dist_display = Values.distance
				dist_txt.text = str(dist_display)
				
			if dist_display == Values.distance:
				state = COUNT_SCORE
				limit = 0.0
			else:
				dist_display += 1
				dist_txt.text = str(dist_display)
		elif state == COUNT_SCORE:
			
			if limit >= 5.0:
				score_display = Values.run_score
				score_txt.txt = str(score_display)
				
			if score_display == Values.run_score:
				state = WAIT_DISPLAY_TOTAL
				limit = 0.0
			else:
				score_display += 1
				score_txt.text = str(score_display)
		elif state == WAIT_DISPLAY_TOTAL and not avoid_retrigger:
			anim.play("show total")
			avoid_retrigger = true
		elif state == COUNT_TOTAL:
			
			if limit >= 5.0:
				total_display = Values.distance + Values.run_score
				total_txt.text = str(total_display)
			
			if total_display == Values.distance + Values.run_score \
			and not anim.current_animation == "conceal":
				await get_tree().create_timer(1.0).timeout
				anim.play("conceal")
				done = true
			else:
				total_display += 1
				total_txt.text = str(total_display)

# Used to wait for key after counting total
"""
func _input(event: InputEvent) -> void:
	if event is InputEventKey \
	and event.pressed \
	and not event.echo \
	and not avoid_retrigger \
	and state == WAIT_FOR_KEY:
		state = WAIT_FADE_OUT
		anim.play("conceal")
"""

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reveal":
		state = COUNT_DISTANCE
	elif anim_name == "show total":
		state = COUNT_TOTAL
		avoid_retrigger = false
	elif anim_name == "conceal":
		get_tree().change_scene_to_file("res://scenes/upgrades.tscn")
