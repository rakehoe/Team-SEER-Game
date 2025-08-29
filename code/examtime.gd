extends Node3D

signal taken

enum Subjects { NONE, ENGLISH, MATH, SCIENCE, ESP}
enum Answers { NONE, A, B, C }
@export var Exam_Room :bool = true
@export var Subject_Room: Subjects = Subjects.NONE
@export_multiline var Exam_List: Array[String]
@export var Exam_Answer_Key: Array[Answers]


@onready var choicesUi = $Exam_Camera/Examchoices
@onready var Button_A = $Exam_Camera/Examchoices/HBoxContainer/A
@onready var Button_B = $Exam_Camera/Examchoices/HBoxContainer/B
@onready var Button_C = $Exam_Camera/Examchoices/HBoxContainer/C
@onready var ExamCamera: Camera3D = $Exam_Camera
@onready var ExamBoard = $Board/Label3D
@onready var Mainlevel = get_parent().get_parent().get_parent()
@onready var tempTaker

var page = 0
var score = 0
var Takers
var morning := true
var exam_taken := false


func _ready():
	print(get_parent().get_parent())
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


func _start_exam():
	emit_signal('taken',true)
	page = 0
	score = 0
	ExamCamera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await get_tree().create_timer(0.5).timeout
	choicesUi.show()
	_page_update()


func _page_update():
	if page < Exam_List.size():
		ExamBoard.text = str(Exam_List[page])
	else:
		_exam_done()


func daystate(states):
	if states == 'Evening':
		morning = false
		exam_taken = false
		_exam_done()
	else: 
		morning = true
	pass


func _exam_done():
	emit_signal('taken',true)
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


@onready var riddles = $DoorRiddle
@onready var fromdoor1 = $FromInside
@onready var fromdoor2 = $FromInside2
@onready var Door2 = $RoomDoor2/Door
@onready var doorcolision = $RoomDoor/DoorCollision
@onready var Door1 = $RoomDoor/Door
@onready var door2colision = $RoomDoor2/DoorCollision
var entered3



func door_open(whatdoor,open):
	if open:
		match whatdoor:
			Door1:
				Door1.get_child(0).play("OpenDoor1")
				await Door1.get_child(0).animation_finished
				Door1.get_child(0).play_backwards("OpenDoor1")
					
			Door2:
				Door2.get_child(0).play("OpenDoor2")
				await Door2.get_child(0).animation_finished
				Door2.get_child(0).play_backwards("OpenDoor2")

func _Door_one_entered(body:Node3D) -> void:
	if body.name == "Ben":
		Takers = body
		if morning and not exam_taken:
			ExamBoard.text = Subjects.keys()[Subject_Room]+" Exam"
			body.talking = true
			_start_exam()
		elif exam_taken:
			door_open(Door1,true)
		riddles._start_riddle(Door1)
	elif body.name == "Guard":
		door_open(Door1,true)

func _Door_two_entered(body: Node3D) -> void:
	if body.name == "Ben":
		Takers = body
		if morning and not exam_taken:
			ExamBoard.text = Subjects.keys()[Subject_Room]+" Exam"
			body.talking = true
			_start_exam()
		
		elif exam_taken:
			door_open(Door2,true)
		riddles._start_riddle(Door2)
		pass
	elif body.name == "Guard":
		door_open(Door2,true)
	pass # Replace with function body.


func _fromdoor2(body: Node3D) -> void:
	if body.name == "Ben" and !Door1.get_child(0).is_playing():
		door_open(Door2,true)
	pass # Replace with function body.


func _fromdoor1(body: Node3D) -> void:
	if body.name == "Ben" and !Door2.get_child(0).is_playing():
		door_open(Door1,true)
	pass # Replace with function body.
