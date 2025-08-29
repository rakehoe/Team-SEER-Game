class_name Bully extends Node3D

signal detected
signal consequences
signal bully_beaten

@onready var Maincharacter: CharacterBody3D = get_parent().get_node('Ben')
@export var Name: String

var Bully_dialogue: Array[String] = [
	"Hey kid, stop!",
	"You cannot pass here, until you do something for me.",
	"I must pass the exam. And you will give me the answer tomorrow.",
	"ARGGHHH!",
	"Hey! Comeback!"
]
@onready var Bully_cam: Camera3D = $Camera3D
@onready var Dialoguetxt = $Dialogue/Label
@onready var Choice = $Dialogue/Choices
@onready var nextbtn :LinkButton = get_node("Dialogue/Label/LinkButton")
@onready var DialogueUi :CanvasLayer = get_node("Dialogue")


var fightback := 75
var escape := 20
var bullytext := 0
var bentext := 0

func _ready() -> void:
	for i in Ben_dialogue.size():
		print("%0d =" % i + Ben_dialogue[i])
	DialogueUi.hide()
	Choice.hide()


func bullyDialogue(page):
	Dialoguetxt.visible_characters = 0
	Dialoguetxt.text = '%s :\t' % Name + Bully_dialogue[page]
	for i in Bully_dialogue[page].length():
		await get_tree().create_timer(0.2).timeout
		Dialoguetxt.visible_characters += i


func benDialogue(page):
	Dialoguetxt.text = ""
	await get_tree().create_timer(0.5).timeout
	Dialoguetxt.visible_characters = 0
	if page < Ben_dialogue.size():
		Dialoguetxt.text = Ben_dialogue[page]
		for i in Ben_dialogue[page].length():
			await get_tree().create_timer(0.2).timeout
			Dialoguetxt.visible_characters += i

func _on_link_button_pressed() -> void:
	Dialoguetxt.text = ""
	await get_tree().create_timer(0.5).timeout
	Dialoguetxt.visible_characters = 0
	match bullytext:
		0:
			bullytext += 1
			bullyDialogue(bullytext)
		1:
			benDialogue(0)
			bullytext += 1
		2:
			bullyDialogue(bullytext)
			bullytext += 1
			nextbtn.hide()
			await get_tree().create_timer(1.0).timeout
			Choice.show()
		3:
			pass # Replace with function body.

func _on_detection_body_entered(body) -> void:
	if body == Maincharacter:
		Bully_cam.current = true
		emit_signal('detected',true)
		await get_tree().create_timer(0.9).timeout
		DialogueUi.show()
		bullyDialogue(bullytext)

func done_chatting():
	DialogueUi.hide()
	emit_signal('detected',false)
	Bully_cam.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
var Ben_dialogue: Array[String] = [
	"Ehh?",
	"You use [ 50 Energy ] to fight back the bully",
	"You use [ 25 Energy ] to fight back the bully",
	"You don't have enough courage to do that action",
	"Your maximum energy has depleted by [ 25 Energy ] for the entire day",
	"Your maximum energy has depleted by [ 20 Energy ] for the entire day",
	"You are forced to accept the bully's order",
	"You have beaten the bully",
	"You have escaped successfully"
]


func _consequences(action,punishment):
	Choice.hide()
	Maincharacter.energy.value -= action
	Maincharacter.current_max_energy -= punishment
	await get_tree().create_timer(2).timeout
	benDialogue(3)
	await get_tree().create_timer(2).timeout
	match action:
		50:
			benDialogue(4)
		25:
			benDialogue(5)
	await get_tree().create_timer(2).timeout
	benDialogue(6)
	await get_tree().create_timer(2).timeout
	done_chatting()


func _action_success(action):
	Choice.hide()
	await get_tree().create_timer(2.0).timeout
	match action:
		'fightback':
			benDialogue(6)
		'escape':
			benDialogue(7)
	await get_tree().create_timer(2.0).timeout
	done_chatting()


func _on_fight_back_pressed() -> void:
	benDialogue(1)
	if Maincharacter.courage.value < fightback:
		_consequences(50,25)
	else:
		_action_success('fightback')

func _on_escape_pressed() -> void:
	benDialogue(2)
	if Maincharacter.courage.value < escape:
		_consequences(25,20)
	else:
		_action_success('escape')


func _on_accept_pressed() -> void:
	done_chatting()
	emit_signal('consequences')
