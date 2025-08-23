extends Node3D
 
@onready var Ben = $Ben
@onready var Top_left = $"Time_Ui"
@onready var Stopwatch = $"Time_Ui/top-left-Ui/Timer"
@onready var Days_label = $"Time_Ui/top-left-Ui/Value/DayCounts"
@onready var Time_Left_Value = $"Time_Ui/top-left-Ui/Value/Countdown"
@onready var DayCycle = $"Time_Ui/top-left-Ui/Text/Time"
var current_daycycle = ["Daytime :", "Nighttime :"]
var Days_count = 0

func _ready() -> void:
	Top_left.hide()
	DayCycle.text = current_daycycle[0]

func _process(_delta: float) -> void:
	Days_label.text = str(Days_count)
	Time_Left_Value.text = "%02d:%02d" % time_left()
	get_tree().call_group("guard", "target_position", Ben.global_transform.origin)

func _on_bully_start_day() -> void:
	startcountdown(0)
	Top_left.show()
	

func changetime():
	if DayCycle.text == current_daycycle[0]:
		startcountdown(0)
		DayCycle.text = current_daycycle[1]
	elif DayCycle.text == current_daycycle[1]:
		startcountdown(1)
		DayCycle.text = current_daycycle[0]
		

func startcountdown(cycle):
	match cycle:
		0:
			Stopwatch.start(120.0)
		1:
			Stopwatch.start(180.0)

func time_left():
	var timeleft = Stopwatch.time_left
	var m = floor(timeleft/ 60)
	var s = int(timeleft) % 60
	return [ m, s ]

func _on_timer_timeout() -> void:
	if DayCycle.text == current_daycycle[1]:
		Days_count += 1
	changetime()
