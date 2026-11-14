extends Node2D

@export var battery: PackedScene
@export var bg: Node2D
@export var box: PackedScene # x-pos 350
@export var env_anim: AnimationPlayer
@export var game_over: GameOver
@export var hud: HUD
@export var player: Player
@export var power_decay_timer: Timer
@export var ramp: PackedScene # x-pos 715
@export var spawn_timer: Timer
@export var transition: Transition

var avoid_retrigger: bool = false
var batt_time: float
var dist_wait: float
var slide: game_bg

func _init():
	Values.waiting = true
	Values.game_over = false
	Values.distance = 0
	Values.run_score = 0
	Values.max_power = Values.base_power + (5 * Values.power_lvl)
	Values.max_durability = Values.base_durability + Values.durability_lvl
	Values.curr_power = Values.max_power
	Values.curr_durability = Values.max_durability
	dist_wait = 0.5 / (1 + Values.speed_lvl)
	batt_time = 0

func _ready():
	transition.open()
	game_over.hide()
	await get_tree().create_timer(1.5).timeout
	Values.waiting = false
	slide = bg.get_child(0, true)
	spawn_timer.start()
	power_decay_timer.wait_time = 1.0 / (1 + Values.speed_lvl)
	power_decay_timer.start()

func _process(delta: float):
	if not Values.waiting:
		batt_time += delta
		dist_wait -= delta
		if dist_wait <= 0 and not Values.game_over:
			Values.distance += 10
			dist_wait = 1.0
		
		if player.check_successful_stunt():
			hud.score_riser_text("+100")
			hud.score_anim()
			env_anim.play("special")
			Values.run_score += 100
		
		if Values.curr_durability < 1 and not avoid_retrigger:
			avoid_retrigger = true
			Values.game_over = true
			slide.state = game_bg.DECEL
			game_over.set_text("WIPEOUT!")
			game_over.show()
			player.wipeout()
		
		if Values.curr_power < 1 and not avoid_retrigger:
			avoid_retrigger = true
			Values.game_over = true
			slide.state = game_bg.DECEL
			game_over.set_text("OUT OF POWER!")
			game_over.show()
			player.stop()
		
		if player.flipping and not player.jumping:
			Values.game_over = true
			slide.state = game_bg.DECEL
			game_over.set_text("WIPEOUT!")
			game_over.show()
			player.wipeout()
		
		var random: int = randi() % 100
		
		if random == 99 and batt_time >= 15:
			batt_time = 0
			var battery_instance = battery.instantiate()
			battery_instance.global_position = Vector2(665, 350)
			add_child(battery_instance)

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
	
	if not Values.player_dodging and not player.jumping and body.is_in_group("battery"):
		body.queue_free()
		Values.curr_power += 3 + (Values.power_lvl)
		if Values.curr_power > Values.max_power:
			Values.curr_power = Values.max_power

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
