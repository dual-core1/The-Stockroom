class_name HUD extends Control

@export var power_meter: Meter
@export var durability_meter: Meter
@export var dist_counter: Label
@export var score_counter: Label
@export var score_riser: Label
@export var anim: AnimationPlayer

func score_anim():
	anim.play("score_rise")
	

func score_riser_text(val: String):
	score_riser.text = val

func _ready():
	power_meter._max = Values.max_power
	power_meter.value = Values.curr_power
	durability_meter._max = Values.max_durability
	durability_meter.value = Values.curr_durability

func _process(delta: float) -> void:
	power_meter.value = Values.curr_power
	durability_meter.value = Values.curr_durability
	dist_counter.text = "%05d" % Values.distance
	score_counter.text = "%06d" % Values.run_score
