extends Node3D

signal ben_look

@onready var temp_target: CSGBox3D = $temptarget


func _ready() -> void:
	$Roof.show()

func _on_ben_looked() -> void:
	emit_signal('ben_look')
	pass # Replace with function body.
