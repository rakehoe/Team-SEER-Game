class_name MyLevels
extends Node3D
 
signal Day_state
signal end_game


@onready var Ben = $Ben
@onready var Top_left := get_node('Time_Ui')
@onready var Stopwatch = $"Time_Ui/top-left-Ui/Timer"
@onready var Days_label = $"Time_Ui/top-left-Ui/Value/DayCounts"
@onready var Time_Left_Value = $"Time_Ui/top-left-Ui/Value/Countdown"
@onready var DayCycle = $"Time_Ui/top-left-Ui/Text/Time"
@onready var Bully_nodes = get_node('Bully')
@onready var DayAnim : AnimationPlayer = get_node('DaysAnimation')
@onready var exam1 := get_node('Map/NavigationRegion3D/Examroom')
@onready var exam2 := get_node('Map/NavigationRegion3D/Examroom2')
@onready var exam3 := get_node('Map/NavigationRegion3D/Examroom3')
@onready var exam4 := get_node('Map/NavigationRegion3D/Examroom4')
@onready var guard := get_node('Map/NavigationRegion3D/Path3D/PathFollow3D/Guard')
@onready var Map := get_node('Map')

var startingpos: Vector3
var startingrot: Vector3
var current_daycycle = ["Morning :", "Evening :"]
@export var morning = 120.0
@export var night = 180.0
var Days_count = 0
var posiblekeylocation := []

func _on_ben_showui() -> void:
	Top_left.show()
	MORNING()
	pass # Replace with function body.

func _ready() -> void:
	DayAnim.play('BasicDay')
	get_node('Ben').connect('medead',_kill_player)
	startingpos = Ben.position
	startingrot = Ben.rotation
	Top_left.hide()

	# Connect all AnswerKeyPlacement nodes' safehere signals
	for node in get_tree().get_nodes_in_group("answerkey_placements"):
		posiblekeylocation.append(node)


# randomizing the answerkey placement
func spawn_answerkey():
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var idx := rng.randi_range(1, posiblekeylocation.size() - 1)
	posiblekeylocation[idx].spawn_ans_key()


func _process(_delta: float) -> void:
	Days_label.text = str(Days_count)
	Time_Left_Value.text = "%02d:%02d" % time_left()
	get_tree().call_group("guard", "target_position", Ben.global_transform.origin)


func MORNING():
	DayAnim.play('BasicDay')
	Map._guard_gone(false)
	Bully_nodes.DialogueUi.hide()
	Bully_nodes.global_position = Bully_nodes.morningpos
	if guard:
		guard.queue_free()
	exam1.exam_taken = false
	exam2.exam_taken = false
	exam3.exam_taken = false
	exam4.exam_taken = false
	DayCycle.text = current_daycycle[0]

	# DayAnim.play('Morning')
	Ben.sit = false
	Ben.talking = false
	Ben.get_node('CameraController/Camera3D').current = true
	emit_signal('Day_state','Morning')
	Stopwatch.start(morning)
	await Stopwatch.timeout
	Transitions(false)

func Transitions(sunisup:bool):
	Stopwatch.stop()
	get_node('Map')._choice(false)
	DayAnim.stop()
	Bully_nodes.Hide_Bully_Ui()
	Bully_nodes.bullytext = 0
	Ben.sit = true
	Ben.talking = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ben.mainUI.show()
	var translabel :RichTextLabel= get_node('Days_transition/Transitioning')
	var transcanvas :CanvasLayer= get_node('Days_transition')
	transcanvas.show()
	translabel.hide()
	Ben.position = startingpos
	Ben.rotation = startingrot
	translabel.visible_characters = 0
	var Transitiontext = [
		"The bell has rung and you were forced to leave the school...",
		"A new day has began..."
	]
	if not sunisup:
		translabel.text = Transitiontext[0]
	elif sunisup:
		translabel.text = Transitiontext[1]
	translabel.show()
	for i in translabel.text.length():
		await get_tree().create_timer(0.05).timeout
		translabel.visible_characters = i
	for i in posiblekeylocation.size():
		posiblekeylocation[i].anim.play_backwards('Open')

	await get_tree().create_timer(5).timeout
	translabel.hide()
	transcanvas.hide()
	if not sunisup:
		NIGHT()
	elif sunisup:
		Days_count += 1
		MORNING()
		for node in get_tree().get_nodes_in_group("answerkey"):
			node.queue_free()
	Ben.sit = false
	Ben.talking = false


func NIGHT():
	Map._guard_gone(true)
	Bully_nodes.DialogueUi.hide()
	Bully_nodes.global_position.y += 10
	if Ben.has_quest:
		spawn_answerkey()
	
	DayAnim.play('BasicNight')
	# DayAnim.play('Evening')
	DayCycle.text = current_daycycle[1]
	emit_signal('Day_state','Evening')
	Stopwatch.start(night)
	await Stopwatch.timeout
	Transitions(true)


func time_left():
	var timeleft = Stopwatch.time_left
	var m = floor(timeleft/ 60)
	var s = int(timeleft) % 60
	return [ m, s ]

func _kill_player():
	print("kill_player")
	emit_signal('end_game',Days_count)
	pass
