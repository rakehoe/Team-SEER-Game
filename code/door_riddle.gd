extends Node3D

signal open_door

@export_multiline var Riddles: Array[String]
@export var Answers: Array[String]
@onready var riddleshow = $Bg/VBoxContainer/ShowRiddle
@onready var riddleans = $Bg/VBoxContainer/Answer

var temp
var result = false
var door
var rng := RandomNumberGenerator.new()
var idx : int

func _ready():
	get_child(0).hide()
	
func _start_riddle(doorname):
	door = doorname
	get_child(0).show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	rng.randomize()
	idx = rng.randi_range(0, Riddles.size()-1)
	riddleshow.text = Riddles[idx]


func _answer_submit(new_text: String) -> void:
	if new_text == Answers[idx]:
		result = true
	else:
		result = false
	emit_signal("open_door",door,result)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	riddleans.text = ""
	get_child(0).hide()
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("ui_cancel") and get_child(0).is_visible_in_tree():
			_answer_submit("")