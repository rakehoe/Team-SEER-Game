extends Node3D

signal open_door

@export_multiline var Riddles: Array[String]
@export var Answers: Array[String]
@onready var riddleshow = $Bg/VBoxContainer/ShowRiddle
@onready var riddleans = $Bg/VBoxContainer/Answer

var globalplayer 
var temp
var result = false
var door
var rng := RandomNumberGenerator.new()
var idx : int
var wrong = 0

func _ready():
	globalplayer = get_parent().get_parent().get_parent().get_parent().get_child(0)
	get_child(0).hide()
	
func _start_riddle(doorname):
	globalplayer.talking = true
	get_child(0).color = '#21423ea2'
	door = doorname
	get_child(0).show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	rng.randomize()
	idx = rng.randi_range(0, Riddles.size()-1)
	riddleshow.text = Riddles[idx]


func _answer_submit(new_text: String) -> void:
	globalplayer.talking = false
	if new_text == Answers[idx]:
		result = true
	else:
		get_child(0).color = '#422121a2'
		wrong += 1
		alert_guard()
		result = false
		await get_tree().create_timer(1).timeout
	emit_signal("open_door",door,result)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	riddleans.text = ""
	get_child(0).hide()
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("ui_cancel") and get_child(0).is_visible_in_tree():
			_answer_submit("")


func alert_guard():
	if wrong == 2:
		var guard = get_parent().get_parent().get_child(1).get_child(0).get_child(0)
		guard.player = globalplayer
		guard.PlayerDetected = true
		wrong = 0
