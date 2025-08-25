@tool
extends Node3D

enum Subjects { NONE, ENGLISH, MATH, SCIENCE, ESP}
@export var Subject_Room: Subjects = Subjects.NONE
@export var Exam_List: PackedStringArray
@export var Exam_Answer_Key: PackedStringArray

@onready var choicesUi = $Exam_Camera/Examchoices
@onready var Button_A = $Exam_Camera/Examchoices/HBoxContainer/A
@onready var Button_B = $Exam_Camera/Examchoices/HBoxContainer/B
@onready var Button_C = $Exam_Camera/Examchoices/HBoxContainer/C
@onready var ExamCamera: Camera3D = $Exam_Camera
@onready var ExamBoard = $Board/Label3D

var page = 0
var score = 0
var Takers
var EnglishExamList = [
	"What is the color of an apple? \n\n A. Red \t B. Blue \t C. Orange",
	"What is the color of a grape? \n\n A. Red \t B. Blue \t C. Orange",
	"What is the color of an orange? \n\n A. Red \t B. Blue \t C. Orange",
	"What is the color of an sky? \n\n A. Red \t B. Blue \t C. Orange"
]

var EnglishAnswerkey = [
	"A", "B", "C", "B"
]

func _ready():
	choicesUi.hide()

func _on_room_door_body_entered(body:Node3D) -> void:
	if body.name == "Ben":
		_start_exam()
		Takers = body
		body.talking = true
		ExamBoard.text = Subjects.keys()[Subject_Room]+" Exam"
		pass


func _start_exam():
	page = 0
	score = 0
	ExamCamera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await get_tree().create_timer(3).timeout
	choicesUi.show()
	_page_update()


func _page_update():
	if page < Exam_List.size():
		ExamBoard.text = Exam_List[page]
	else:
		_exam_done()


func _exam_done():
	match score:
		5:
			Takers.courage.value += 10
		4: 
			Takers.courage.value += 7
		3: 
			Takers.courage.value += 5
		2: 
			Takers.courage.value += 2
		1: 
			Takers.courage.value += 1
		_: 
			Takers.courage.value += 0
	Takers.talking = false
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
	_answer_checking("A")
	
	
func _on_b_pressed() -> void:
	_answer_checking("B")
	
	
func _on_c_pressed() -> void:
	_answer_checking("C")
