extends Node3D

@onready var Ui = $Time_Ui
@onready var countdown = $Time_Ui/Time/Timer
@onready var Days_label = $Time_Ui/Days/Counts
@onready var Countdown_label = $Time_Ui/Time/Countdown
var Days_count = 0

func _ready() -> void:
	Days_label.text = str(Days_count)
	Ui.hide()
	$Time_Ui/Days/Counts.hide()

func _process(delta: float) -> void:
	Countdown_label.text = "%02d:%02d" % time_left()

func _on_bully_start_day() -> void:
	$Time_Ui/Days/Counts.show()
	startcountdown(120.0)
	

func changetime():
	pass

func startcountdown(time):
	countdown.start(time)

func time_left():
	var timeleft = countdown.time_left
	var m = floor(timeleft/ 60)
	var s = int(timeleft) % 60
	return [ m, s ]

func _on_timer_timeout() -> void:
	changetime()


func _on_ben_showui(temp) -> void:
	if temp:
		Ui.show()
	pass # Replace with function body.
