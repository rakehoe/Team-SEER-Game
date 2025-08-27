extends Node3D

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
@onready var ExamBoard = $Board/Label3D

var page = 0
var score = 0
var Takers
@onready var Mainlevel = get_parent().get_parent().get_parent()
@onready var tempTaker
func _ready():
	for i in Mainlevel.get_child_count():
		if Mainlevel.get_child(i).name == "Ben":
			tempTaker = Mainlevel.get_child(i)
	choicesUi.hide()
	Mainlevel.connect('Day_state',daystate)


func _on_room_door_body_entered(body:Node3D) -> void:
	if body.name == "Ben":
		Takers = body
		print(Takers)
		if Mainlevel.DayCycle.text == Mainlevel.current_daycycle[0] and Mainlevel.Stopwatch.get_time_left()==0:
			body.talking = true
			ExamBoard.text = Subjects.keys()[Subject_Room]+" Exam"
			_start_exam()
			pass
	else:
		return


func _start_exam():
	page = 0
	score = 0
	Mainlevel.MORNING()
	ExamCamera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await get_tree().create_timer(3).timeout
	choicesUi.show()
	_page_update()


func _page_update():
	if page < Exam_List.size():
		ExamBoard.text = str(Exam_List[page])
	else:
		_exam_done()


func daystate(states):
	if states == 'Evening':
		_exam_done()
	pass


func _exam_done():
	match score:
		5:
			tempTaker.courage.value += 10
		4: 
			tempTaker.courage.value += 7
		3: 
			tempTaker.courage.value += 5
		2: 
			tempTaker.courage.value += 2
		1: 
			tempTaker.courage.value += 100
		_: 
			pass
	tempTaker.talking = false
	ExamCamera.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ExamBoard.text = Subjects.keys()[Subject_Room]+" Exam"
	choicesUi.hide()


func _answer_checking(ans):
	if page < Exam_Answer_Key.size():
		if ans == Exam_Answer_Key[page]:
			score += 1
		page += 1
		_page_update()


func _on_a_pressed() -> void:
	_answer_checking(1)
	
	
func _on_b_pressed() -> void:
	_answer_checking(2)
	
	
func _on_c_pressed() -> void:
	_answer_checking(3)
