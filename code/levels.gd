extends Node3D

@onready var Ui = $Time_Ui
@onready var countdown = $Time_Ui/Time/Timer
@onready var Days_label = $Time_Ui/Days/Counts
@onready var Countdown_label = $Time_Ui/Time/Countdown
@onready var DayCycle = $Time_Ui/Time
var current_daycycle = ["Daytime", "Nighttime"]
var Days_count = 0

func _ready() -> void:
	DayCycle.text = current_daycycle[0]
	Ui.hide()
	Days_label.hide()
	

func _process(_delta: float) -> void:
	Days_label.text = ": " + str(Days_count)
	Countdown_label.text = ": %02d:%02d" % time_left()

func _on_bully_start_day() -> void:
	Days_label.show()
	startcountdown(current_daycycle[0])
	

func changetime():
	if DayCycle.text == current_daycycle[0]:
		startcountdown(current_daycycle[1])
		DayCycle.text = current_daycycle[1]
	elif DayCycle.text == current_daycycle[1]:
		startcountdown(current_daycycle[0])
		DayCycle.text = current_daycycle[0]
		

func startcountdown(cycle):
	match cycle:
		"Daytime":
			countdown.start(120.0)
		"Nighttime":
			countdown.start(180.0)

func time_left():
	var timeleft = countdown.time_left
	var m = floor(timeleft/ 60)
	var s = int(timeleft) % 60
	return [ m, s ]

func _on_timer_timeout() -> void:
	if DayCycle.text == current_daycycle[1]:
		Days_count += 1
	changetime()


func _on_ben_showui(temp) -> void:
	if temp:
		Ui.show()
	pass # Replace with function body.
