extends Node3D

signal ben_look
signal exam_time
@export var Maincharacter: CharacterBody3D
@onready var temp_target: CSGBox3D = $temptarget
var entered = false

func _ready() -> void:
	$Roof.show()

func _on_ben_looked() -> void:
	emit_signal('ben_look')
	pass # Replace with function body.


func _on_room_1_door_body_entered(body: Node3D) -> void:
	if body == Maincharacter and !entered:
		emit_signal('exam_time')
		entered = true
	pass # Replace with function body.
