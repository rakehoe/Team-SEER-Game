@tool
extends Node3D

@onready var list = $QuestList
var day_state = 0
var Morning_quest = [
	"1. Interact with the bully in the hallway.",
	"2. Finish your exam in a specific room.",
	"3. Roam around the map after your exam."
]
var Night_quest = [
	"1. Find the right room.",
	"2. Get the answer key.",
	"3. Avoid getting caught by the guard."    
]
var completed_quest = 0

func _ready() -> void:
	for i in list.get_child_count():
		list.get_child(i).text = Morning_quest[i]
		++i
	pass
	
func _process(_delta):
	for i in list.get_child_count():
		if day_state == 0:
			list.get_child(i).text = Morning_quest[i]
		elif day_state == 1:
			list.get_child(i).text = Night_quest[i]
		++i	
		


func _on_levels_day_state(state) -> void:
	match state:
		"Morning":
			day_state = 0
		"Evening":
			day_state = 1
		_:
			pass
	pass # Replace with function body.
