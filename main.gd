extends Node3D


func _ready():
	get_node('Levels/Ben').connect('medead',_kill_player)


func _kill_player():
	var old_levels = get_node('Levels')
	var parent = old_levels.get_parent()
	var index = parent.get_children().find(old_levels)
	old_levels.queue_free()
	
	await get_tree().create_timer(2).timeout
	var level = preload("res://scenes/Levels.tscn")
	var instance = level.instantiate()
	instance.name = "Levels"
	parent.add_child(instance)
	parent.move_child(instance, index)
	
	get_node('Levels/Ben').connect('medead',_kill_player)
	pass
