class_name game_bg extends Sprite2D

var scroll_speed
var progress: int = 0
var t: float

enum {
	ACCEL,
	CONST,
	DECEL,
	STOP
}

var state = CONST

func _process(delta: float) -> void:
	if state == ACCEL:
		t += delta
		if t > 1:
			t = 1
			state = CONST
		scroll_speed = lerp(0, Values.base_speed + (50 * Values.speed_lvl), t)
	elif state == CONST:
		t = 0
		scroll_speed = Values.base_speed + (50 * Values.speed_lvl)
	elif state == DECEL:
		t += delta
		if t > 1:
			t = 1
			state = STOP
		scroll_speed = lerp(Values.base_speed + (50 * Values.speed_lvl), 0, t)
	elif state == STOP:
		scroll_speed = 0
	
	progress += scroll_speed * delta
	if abs(640 - progress) < 2:
		progress = 0
	region_rect = Rect2(progress, 0, 640, 343)
