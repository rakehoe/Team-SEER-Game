extends Node3D

signal taken

enum Subjects { NONE, ENGLISH, MATH, SCIENCE, ESP}
enum Answers { NONE, A, B, C }
@export var Subject_Room: Subjects = Subjects.NONE
@export_multiline var Exam_List: Array[String]
@export var Exam_Answer_Key: Array[Answers]


@onready var choicesUi = $Exam_Camera/Examchoices
@onready var Button_A = $Exam_Camera/Examchoices/HBoxContainer/A
@onready var Button_B = $Exam_Camera/Examchoices/HBoxContainer/B
@onready var Button_C = $Exam_Camera/Examchoices/HBoxContainer/C
@onready var ExamCamera: Camera3D = $Exam_Camera
@onready var SubjectAssigned := get_node('Node3D/Node3D/Subject')
@onready var ExamBoard := get_node('Node3D/Node3D/Question')
@onready var Mainlevel = get_parent().get_parent().get_parent()
@onready var tempTaker

var page = 0
var score = 0
var Takers
var morning := true
var exam_taken := false


func _ready():
	SubjectAssigned.text = Subjects.keys()[Subject_Room]+" Exam"
	get_parent().get_parent().connect('exam_taken',_stay_open)
	riddles.connect("open_door", door_open)
	for i in Mainlevel.get_child_count():
		if Mainlevel.get_child(i).name == "Ben":
			tempTaker = Mainlevel.get_child(i)
	choicesUi.hide()
	Mainlevel.connect('Day_state',daystate)


func _process(_delta):
	if Door1.get_child(0).is_playing():
		doorcolision.disabled = true
		pass
	elif Door2.get_child(0).is_playing():
		door2colision.disabled = true
	elif !Door1.get_child(0).is_playing() or !Door2.get_child(0).is_playing():
		doorcolision.disabled = false
		door2colision.disabled = false
		pass


func _stay_open(stay):
	if stay:
		exam_taken = stay


func _start_exam(takenfrom):
	print(takenfrom)
	print(exam_taken)
	print(morning)
	if morning and exam_taken:
		door_open( takenfrom, true, false )
	elif morning and not exam_taken:
		exam_taken = true
		emit_signal('taken',true)
		tempTaker.talking = true
		tempTaker.mainUI.hide()

		page = 0
		score = 0
		ExamCamera.current = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		await get_tree().create_timer(0.5).timeout
		choicesUi.show()
		_page_update(takenfrom)


func _page_update(takenfrom):
	if page < Exam_List.size():
		ExamBoard.text = str(Exam_List[page])
	else:
		_exam_done(takenfrom)


func daystate(states):
	var _dump = null
	if states == 'Evening':
		morning = false
		_exam_done(_dump)
	else: 
		morning = true
	pass


var total :int = Exam_List.size()
var couragegain :int
func _exam_done(takenfrom):
	if score == total:
		tempTaker.courage.value += 15
		couragegain = 15
	elif score == total * 0.75:
		tempTaker.courage.value += 10
		couragegain = 10
	elif score == total * 0.5:
		tempTaker.courage.value += 5
		couragegain = 5
	elif score == total * 0.25:
		tempTaker.courage.value += 3
		couragegain = 3
	elif score == total * 0.10:
		tempTaker.courage.value += 1
		couragegain = 1
	ExamBoard.text = "Your total score is : %1d \n 
	Your courage is increase by : %1d" % [score,couragegain]
	await get_tree().create_timer(2).timeout
	tempTaker.talking = false
	ExamCamera.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	emit_signal('taken',true)
	door_open(takenfrom,true,false)
	choicesUi.hide()
	Mainlevel.Top_left.show()
	tempTaker.mainUI.show()


func _answer_checking(ans):
	var checked :String
	var _dump = null
	if page < Exam_Answer_Key.size():
		if ans == Exam_Answer_Key[page]:
			score += 1
			checked = "Correct!"
		else:
			checked = "Wrong!"
		page += 1
		ExamBoard.text = checked
		await get_tree().create_timer(1).timeout
		_page_update(_dump)


func _on_a_pressed() -> void:
	_answer_checking(1)
	
	
func _on_b_pressed() -> void:
	_answer_checking(2)
	
	
func _on_c_pressed() -> void:
	_answer_checking(3)


@onready var riddles = $DoorRiddle
@onready var fromdoor1 = $FromInside
@onready var fromdoor2 = $FromInside2
@onready var Door2 := get_node("RoomDoor2/Door")
@onready var doorcolision = $RoomDoor/DoorCollision
@onready var Door1 := get_node("RoomDoor/Door")
@onready var door2colision = $RoomDoor2/DoorCollision
var entered



func door_open(whatdoor,open,close):
	if open and not entered:
		print('this opens')
		print(whatdoor)
		match whatdoor:
			Door1:
				Door1.get_child(0).play("OpenDoor1")
				await Door1.get_child(0).animation_finished
					
			Door2:
				Door2.get_child(0).play("OpenDoor2")
				await Door2.get_child(0).animation_finished
	elif close:
		print('this close')
		print(whatdoor)
		match whatdoor:
			Door1:
				Door1.get_child(0).play_backwards("OpenDoor1")
				await Door1.get_child(0).animation_finished
					
			Door2:
				Door2.get_child(0).play_backwards("OpenDoor2")
				await Door2.get_child(0).animation_finished
		

func _Door_one_entered(body:Node3D) -> void:
	if body.name == "Guard":
		door_open( Door1, true, false )

func _Door_two_entered(body: Node3D) -> void:
	if body.name == "Guard":
		door_open( Door2, true, false )
	pass # Replace with function body.


func _fromdoor2(body: Node3D) -> void:
	if body.name == "Ben" and !Door1.get_child(0).is_playing():
		await Door2.get_child(0).animation_finished
		door_open(Door2, false, true)
	pass # Replace with function body.


func _fromdoor1(body: Node3D) -> void:
	if body.name == "Ben" and !Door2.get_child(0).is_playing():
		await Door1.get_child(0).animation_finished
		door_open(Door1, false, true)
	pass # Replace with function body.


func Door2_exits(body: Node3D) -> void:
	if body.name == "Ben" and entered:
		entered = false
	pass # Replace with function body.


func Door1_exits(body: Node3D) -> void:
	if body.name == "Ben" and entered:
		entered = false
	pass # Replace with function body.


func _player_in(body: Node3D, is_it_in_yet: bool) -> void:
	if body.name == "Ben":
		if is_it_in_yet:
			body.entered_room = true
		else:
			body.entered_room = false
