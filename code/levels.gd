extends Node3D
 
signal Day_state

@onready var Ben = $Ben
@onready var Top_left = $"Time_Ui"
@onready var Stopwatch = $"Time_Ui/top-left-Ui/Timer"
@onready var Days_label = $"Time_Ui/top-left-Ui/Value/DayCounts"
@onready var Time_Left_Value = $"Time_Ui/top-left-Ui/Value/Countdown"
@onready var DayCycle = $"Time_Ui/top-left-Ui/Text/Time"
var startingpos: Vector3
var startingrot: Vector3
var current_daycycle = ["Morning :", "Evening :"]
@export var morning = 120.0
@export var night = 180.0
var Days_count = 0

func _ready() -> void:
	emit_signal('Day_state','Morning')
	startingpos = Ben.position
	startingrot = Ben.rotation
	Top_left.hide()
	DayCycle.text = current_daycycle[0]

func _process(_delta: float) -> void:
	Days_label.text = str(Days_count)
	Time_Left_Value.text = "%02d:%02d" % time_left()
	get_tree().call_group("guard", "target_position", Ben.global_transform.origin)

func _on_bully_start_day(_temp,_temp2) -> void:
	Top_left.show()
	
func MORNING():
	Ben.sit = false
	emit_signal('Day_state','Morning')
	DayCycle.text = current_daycycle[0]
	Stopwatch.start(morning)
	await Stopwatch.timeout
	NIGHT()
	Ben.position = startingpos
	Ben.rotation = startingrot

func NIGHT():
	Ben.sit = false
	emit_signal('Day_state','Evening')
	Stopwatch.start(night)
	DayCycle.text = current_daycycle[1]
	await Stopwatch.timeout
	MORNING()
	Days_count += 1
	Ben.position = startingpos
	Ben.rotation = startingrot

func time_left():
	var timeleft = Stopwatch.time_left
	var m = floor(timeleft/ 60)
	var s = int(timeleft) % 60
	return [ m, s ]

func _on_map_exam_time() -> void:
	MORNING()
	pass # Replace with function body.
# 56
