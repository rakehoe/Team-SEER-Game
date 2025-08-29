extends Node3D

signal stop_player

signal exam_taken


@export var Maincharacter: CharacterBody3D
@onready var instructions = $EntraceExitConfirmation
@onready var labelins = $EntraceExitConfirmation/VBoxContainer/ExitEntrance
var entered = false
var side = false

func _ready() -> void:
	guard.connect("gone",_guard_gone)
	instructions.hide()
	$Roof.show()


func _on_exams(take):
	emit_signal('exam_taken',take)

# Entrance / Exit codes
func _entered(body):
	if body == Maincharacter:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		emit_signal('stop_player',true)
		instructions.show()

func _choice(done):
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var insides = get_node('CSGBox3D2/Entrance/inside')
	var outsides = get_node('CSGBox3D2/Exit/outside')
	if done:
		await get_tree().create_timer(0.5).timeout
	emit_signal('stop_player',false)
	instructions.hide()
	if done and side:
		Maincharacter.position = insides.global_position
	elif done and !side:
		Maincharacter.position = outsides.global_position

func _on_exit_body_entered(body:Node3D) -> void:
	side = false
	labelins.text = "Do you want to exit?"
	_entered(body)

func _on_entrance_body_entered(body:Node3D) -> void:
	labelins.text = "Do you want to enter?"
	side = true
	_entered(body)

func _on_no_pressed() -> void:
	_choice(false)

func _on_yes_pressed() -> void:
	_choice(true)
# End of Entrance/ Exit codes

@onready var guard = $NavigationRegion3D/Path3D/PathFollow3D/Guard
@onready var pathfollow = $NavigationRegion3D/Path3D/PathFollow3D


func _guard_gone(): 
	var guardnode = preload("res://scenes/guard.tscn")
	var instance = guardnode.instantiate()
	instance.name = "Guard"
	await get_tree().create_timer(2.0).timeout
	pathfollow.add_child(instance)
	guard = $NavigationRegion3D/Path3D/PathFollow3D/Guard
	guard.connect("gone",_guard_gone)
