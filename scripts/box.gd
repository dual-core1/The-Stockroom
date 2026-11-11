extends Node2D

var speed: float

func _ready():
	speed = Values.base_speed + (50 * Values.speed_lvl)
	add_to_group("box")

func _physics_process(delta: float) -> void:
	if not Values.game_over:
		position.x -= speed * delta
		if position.x <= -70:
			queue_free()
