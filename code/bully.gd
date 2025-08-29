class_name Bully extends Node3D

signal detected
signal bully_beaten

@onready var Maincharacter: CharacterBody3D = get_parent().get_node('Ben')
@export var Name: String

@onready var Bully_cam: Camera3D = $Camera3D
@onready var Dialoguetxt = $Dialogue/Label
@onready var Choice = $Dialogue/Choices
@onready var nextbtn :LinkButton = get_node("Dialogue/Label/LinkButton")
@onready var DialogueUi :CanvasLayer = get_node("Dialogue")

@onready var morningpos = self.get_global_position()

var fightback := 75
var escape := 20
var bullytext := 0
var questsubmit := false

func _ready() -> void:
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
	nextbtn.hide()
	Dialoguetxt.text = ""
	await get_tree().create_timer(0.5).timeout
	Dialoguetxt.visible_characters = 0
	match bullytext:
		0:
			bullytext += 1
			bullyDialogue(bullytext)
			nextbtn.show()
		1:
			benDialogue(0)
			bullytext += 1
			nextbtn.show()
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
		DialogueUi.visible = true
		nextbtn.visible = true
		if not questsubmit:
			bullyDialogue(bullytext)
		elif questsubmit:
			Questdialogue()


# ending the bully convo
func done_chatting():
	DialogueUi.visible = false
	Choice.visible = false
	emit_signal('detected',false)
	Bully_cam.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



var Bully_dialogue: Array[String] = [
	"Hey kid, stop!",
	"You cannot pass here, until you do something for me.",
	"I must pass the exam. And you will give me the answer tomorrow.",
	"ARGGHHH!",
	"Hey! Comeback!",
	"Hey kid, where's my answer key?",
	"Now I'm gonna fail the exam because of you!",
	"I'll see you again tomorrow!"
	
]
	
var Ben_dialogue: Array[String] = [
	"Ehh?",
	"You use [ 50 Energy ] to fight back the bully",
	"You use [ 25 Energy ] in trying to escape",
	"You don't have enough courage to do that action",
	"Your maximum energy has depleted by [ 25 Energy ] for the entire day",
	"Your maximum energy has depleted by [ 20 Energy ] for the entire day",
	"You are forced to accept the bully's order",
	"You have beaten the bully",
	"You have escaped successfully",
	"You don't have the answerkey to give to the bully",
	"You gave the answerkey to the bully"
]

# if you acceptet the bully's order
func Questdialogue():
	bullyDialogue(5)
	if !Maincharacter.has_answerkey:
		await get_tree().create_timer(3.5).timeout
		benDialogue(9)
		await get_tree().create_timer(3.5).timeout
		bullyDialogue(6)
	else:
		await get_tree().create_timer(3.5).timeout
		benDialogue(10)
	await get_tree().create_timer(3.5).timeout
	bullyDialogue(7)
	done_chatting()
	self.global_position.y += 20
	Maincharacter.has_answerkey = false
	Maincharacter.has_quest = false
	questsubmit = false

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
	Maincharacter.has_quest = true
	await get_tree().create_timer(2).timeout
	done_chatting()
	self.global_position.y += 20


func _action_success(action):
	Choice.hide()
	await get_tree().create_timer(2.0).timeout
	match action:
		'fightback':
			benDialogue(6)
			await get_tree().create_timer(2).timeout
			bullyDialogue(3)
		'escape':
			benDialogue(7)
			await get_tree().create_timer(2).timeout
			bullyDialogue(4)
	await get_tree().create_timer(2.0).timeout
	emit_signal('bully_beaten',action)
	done_chatting()


func _on_fight_back_pressed() -> void:
	benDialogue(1)
	if Maincharacter.courage.value < fightback:
		_consequences(50,25)
		Maincharacter.has_quest = true
	else:
		_action_success('fightback')


func _on_escape_pressed() -> void:
	benDialogue(2)
	if Maincharacter.courage.value < escape:
		_consequences(25,20)
		Maincharacter.has_quest = true
	else:
		_action_success('escape')


func _on_accept_pressed() -> void:
	done_chatting()
	self.global_position.y += 20
	questsubmit = true
	Maincharacter.has_quest = true

# hiding all UI
func Hide_Bully_Ui():
	DialogueUi.hide()
	Bully_cam.current = false
	self.global_position = morningpos
