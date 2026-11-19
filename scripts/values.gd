extends Node

const costs: Array[int] = [
	50,
	100,
	500,
	1000,
	2000,
	5000,
	7000,
	9000,
	10000,
	11000,
	0        # This is a placeholder value to prevent out of bounds errors.
]            # The max is 9, not 10

const base_power: int = 10
const base_speed: int = 200
const base_durability: int = 2

var power_lvl: int = 0
var speed_lvl: int = 0
var durability_lvl: int = 0

var curr_power: int = 0
var curr_durability: int = 0
var max_power: int = 0
var max_durability: int = 0
var distance: int = 0
var run_score: int = 0
var points: int = 0

var waiting: bool = true
var game_over: bool = false
var player_dodging: bool = false
