extends StaticBody3D

@onready var spawningpoints = $Spawningpoints
var spawnlocation = []

var foods = preload("res://scenes/Food.tscn")

func _ready():
	for i in spawningpoints.get_child_count():
		var instance = foods.instantiate()
		spawningpoints.get_child(i).add_child(instance)
		# spawnlocation.append(spawningpoints.get_child(i).position)
		
	pass
