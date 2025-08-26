extends Node3D

signal stop_player
signal exam_time

@export var Maincharacter: CharacterBody3D
@onready var instructions = $EntraceExitConfirmation
@onready var labelins = $EntraceExitConfirmation/VBoxContainer/ExitEntrance
var entered = false
var side = false

func _ready() -> void:
	instructions.hide()
	$Roof.show()

func _on_room_1_door_body_entered(body: Node3D) -> void:
	if body == Maincharacter and !entered:
		emit_signal('exam_time')
		entered = true
	pass # Replace with function body.

# Entrance / Exit codes
func _entered(body):
	if body == Maincharacter:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		emit_signal('stop_player',true)
		instructions.show()

func _choice(done):
	if done:
		await get_tree().create_timer(0.5).timeout
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	emit_signal('stop_player',false)
	instructions.hide()
	if done and side:
		Maincharacter.position.z += 10
	elif done and !side:
		Maincharacter.position.z -= 10

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
