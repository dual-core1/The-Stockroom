class_name Meter extends Control

@export var bars: Array[ColorRect] = [
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	null,
]

var value: float = 0
var _max: float = 10

var live_color: Color = Color(1, 1, 1, 1)
var dead_color: Color = Color((46.0/255.0), (56.0/255.0), (126.0/255.0), 1)

func _ready():
	for i in 10:
		bars[i] = get_node("square"+str(i))
		bars[i].color = dead_color

func _process(delta: float) -> void:
	var live_bars: int
	live_bars = (value / _max) * 10
	for i in 10:
		if i < live_bars:
			bars[i].color = live_color
		else:
			bars[i].color = dead_color
