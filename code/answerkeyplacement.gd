extends Node3D


@onready var keypos = get_node("Answerkeypos")
@onready var anim :AnimationPlayer = get_node('cabinetDoor/Cabinet')
var spawns := false


func _ready():
	add_to_group("answerkey_placements")
	

func _process(_delta):
	if spawns:
		pass


func spawn_ans_key():
	var anskey = preload("res://scenes/ExamRooms/ansker_key.tscn")
	var instance = anskey.instantiate()
	instance.name = "key"
	spawns = true
	instance.visible = true
	instance.add_to_group("answerkey")
	keypos.add_child(instance)
	print('spawned')
