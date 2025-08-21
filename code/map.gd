extends Node3D

@onready var temp_target: CSGBox3D = $temptarget

func _ready() -> void:
	$Roof.show()

func _on_ben_pointed(target) -> void:
	temp_target = target
	pass # Replace with function body.


func _on_ben_snacks(snacks) -> void:
	pass # Replace with function body.
