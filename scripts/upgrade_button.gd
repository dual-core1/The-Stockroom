# The day I wrote this script, I learned GDScript had a match statement
# that works like C++'s switch statement...
class_name UpgradeButton extends Button

enum ButtonType {
	NONE,
	POWER,
	SPEED,
	DURABILITY
}

@export var type: ButtonType = ButtonType.NONE

# this one is extremely simple only because of the specific costs in values.gd
func format_cost(val: int) -> String:
	if val > 9000:
		@warning_ignore("integer_division") # I KNOW!
		return str(int(val / 1000)) + "K"
	else:
		return str(val)

func _process(_delta: float):
	match type:
		ButtonType.POWER:
			if Values.power_lvl == 10:
				text = "MAX"
			else:
				text = format_cost(Values.costs[Values.power_lvl])
		ButtonType.SPEED:
			if Values.speed_lvl == 10:
				text = "MAX"
			else:
				text = format_cost(Values.costs[Values.speed_lvl])
		ButtonType.DURABILITY:
			if Values.durability_lvl == 10:
				text = "MAX"
			else:
				text = format_cost(Values.costs[Values.durability_lvl])

func _pressed() -> void:
	match type:
		ButtonType.POWER:
			if Values.points >= Values.costs[Values.power_lvl] and \
			Values.power_lvl < 10:
				Values.points -= Values.costs[Values.power_lvl]
				Values.power_lvl += 1
		ButtonType.SPEED:
			if Values.points >= Values.costs[Values.speed_lvl] and \
			Values.speed_lvl < 10:
				Values.points -= Values.costs[Values.speed_lvl]
				Values.speed_lvl += 1
		ButtonType.DURABILITY:
			if Values.points >= Values.costs[Values.durability_lvl] and \
			Values.durability_lvl < 10:
				Values.points -= Values.costs[Values.durability_lvl]
				Values.durability_lvl += 1
