extends Node2D

var score_wait: float
@export var transition: Transition
@export var box: PackedScene # x-pos 350
@export var ramp: PackedScene # x-pos 715
@export var spawn_timer: Timer
@export var power_decay_timer: Timer
@export var bg: Node2D
@export var hud: HUD
@export var player: Player
@export var env_anim: AnimationPlayer

var slide: game_bg
var avoid_retrigger: bool = false

func _init():
	Values.waiting = true
	Values.game_over = false
	Values.distance = 0
	Values.run_score = 0
	Values.max_power = Values.base_power + (5 * Values.power_lvl)
	Values.max_durability = Values.base_durability + Values.durability_lvl
	Values.curr_power = Values.max_power
	Values.curr_durability = Values.max_durability
	score_wait = 0.5 / (1 + Values.speed_lvl)

func _ready():
	transition.open()
	await get_tree().create_timer(1.5).timeout
	Values.waiting = false
	slide = bg.get_child(0, true)
	spawn_timer.start()
	power_decay_timer.wait_time = 1.0 / (1 + Values.speed_lvl)
	power_decay_timer.start()

func _process(delta: float):
	if not Values.waiting:
		score_wait -= delta
		if score_wait <= 0 and not Values.game_over:
			Values.distance += 10
			score_wait = 1.0
		
		if player.check_successful_stunt():
			hud.score_riser_text("+100")
			hud.score_anim()
			env_anim.play("special")
			Values.run_score += 100
		
		if Values.curr_durability < 1 and not avoid_retrigger:
			avoid_retrigger = true
			Values.game_over = true
			slide.state = game_bg.DECEL
			player.wipeout()
		
		if player.flipping and not player.jumping:
			Values.game_over = true
			slide.state = game_bg.DECEL
			player.wipeout()
			

# for the spawn timer, which was originally just "Timer"
func _on_timer_timeout() -> void:
	var random: int = randi() % 2
	
	if random == 1:
		var ramp_instance = ramp.instantiate()
		ramp_instance.global_position = Vector2(715, 350)
		add_child(ramp_instance)
	else:
		var box_instance = box.instantiate()
		box_instance.global_position = Vector2(672, 350)
		add_child(box_instance)
	
	spawn_timer.start(randf_range(3, 7))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not Values.player_dodging:
		if body.is_in_group("box"):
			slide.state = game_bg.ACCEL
			Values.curr_durability -= 1
		elif body.is_in_group("ramp"):
			player.jump()
	elif Values.player_dodging:
		if body.is_in_group("box"):
			var this_box: Box = body as Box
			this_box.dodged = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("box"):
		var this_box: Box = body as Box
		if this_box.dodged:
			hud.score_riser_text("+50")
			hud.score_anim()
			Values.run_score += 50

func _on_power_decay_timeout() -> void:
	Values.curr_power -= 1
	power_decay_timer.start(1.0 / (1 + Values.speed_lvl))
