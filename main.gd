extends Node3D


func _ready():
	get_node('Levels/Ben').connect('medead',_kill_player)


func _kill_player():
	print(get_node('Levels').name)
	get_node('Levels').queue_free()
	var level = preload("res://scenes/Levels.tscn")
	var instance = level.instantiate()
	instance.name = "Levels"
	add_child(instance)
	print(instance.name)
	pass
