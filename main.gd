extends Node3D

@onready var endscene: CanvasLayer
@onready var endtext: RichTextLabel

var daysbeaten : int = 0
var endtxtpool : Array[String] = [
	"Congratulation on beating the game \n You beat the game for %0d days" % daysbeaten,
	"You Died \n You survived for %0d days" % daysbeaten
]

func _ready():
	endscene = get_node('End Scene')
	endtext = get_node('End Scene/ColorRect/content')
	endscene.visible = false
	get_node('Levels').connect('end_game',_reset)
	pass


func _reset(totaldays):
	daysbeaten = totaldays
	var old_levels = get_node('Levels')
	var parent = old_levels.get_parent()
	var index = parent.get_children().find(old_levels)
	old_levels.queue_free()
	
	_end_content()
	await get_tree().create_timer(2).timeout
	var level = preload("res://scenes/Levels.tscn")
	var instance = level.instantiate()
	instance.name = "Levels"
	parent.add_child(instance)
	parent.move_child(instance, index)
	get_node('Levels').connect('end_game',_reset)
	
	pass


func _end_content():
	endscene.visible = true
	endtext.visible_characters = 0
	endtext.text = endtxtpool[1]
	for i in endtext.text:
		endtext.visible_characters += 2
		await get_tree().create_timer(0.02).timeout
	await get_tree().create_timer(2).timeout
	endscene.visible = false
