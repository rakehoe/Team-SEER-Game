extends Node3D

signal stop_player
signal exam_taken


@export var Maincharacter: CharacterBody3D
@onready var instructions = $EntraceExitConfirmation
@onready var labelins = $EntraceExitConfirmation/VBoxContainer/ExitEntrance
var entered = false
var side = false

func _ready() -> void:
	if guard:
		guard.connect("gone", _guard_gone)
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
	var daystate = get_parent().DayCycle.text

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
		match daystate:
			"Morning :":
				get_parent().Transitions(false)
			"Evening :":
				get_parent().Transitions(true)
		Maincharacter.position = outsides.global_position

func _on_exit_body_entered(body:Node3D) -> void:
	var daystate = get_parent().DayCycle.text
	side = false
	match daystate:
		"Morning :":
			labelins.text = "Do you want to skip the morning?"
		"Evening :":
			labelins.text = "Do you want to skip the night?"
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

@onready var guard := get_node('NavigationRegion3D/Path3D/PathFollow3D/Guard')
@onready var pathfollow = $NavigationRegion3D/Path3D/PathFollow3D

func _guard_gone(spawn_again):
	if not spawn_again and guard:
		guard.queue_free()
		return
	var guardnode = preload("res://scenes/guard.tscn")
	var instance = guardnode.instantiate()
	instance.name = "Guard"
	await get_tree().create_timer(3.0).timeout
	if spawn_again:
		pathfollow.add_child(instance)
		guard = get_node('NavigationRegion3D/Path3D/PathFollow3D/Guard')
		if guard:
			guard.connect("gone",_guard_gone)
