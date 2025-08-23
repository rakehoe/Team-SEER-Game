class_name Bully extends MeshInstance3D

signal detected
signal start_day

@export var Maincharacter: CharacterBody3D

@export var Name: String
@onready var Bully_cam: Camera3D = $Camera3D
@onready var Printed_dialogue = $Dialogue/Label
@onready var Choice = $Dialogue/Choices
var current_dialogue = 1


func _ready() -> void:
	$Dialogue.hide()
	Choice.hide()

func dialogue(page):
	match page:
		1: 
			text_animation()
			Printed_dialogue.text = Name + ": Hey kid, stop!"
		2:
			text_animation()
			Printed_dialogue.text = Name + ": You cannot pass here, until you do something for me."
		3:
			text_animation()
			Printed_dialogue.text = "Ben: ??"
		4:
			text_animation()
			Printed_dialogue.text = Name + ": I must pass the exam. And you will give me the answer tomorrow."
			$Dialogue/Label/LinkButton.hide()
			await get_tree().create_timer(3.0).timeout
			Choice.show()
			

func text_animation():
	var i = 0
	Printed_dialogue.visible_ratio = 0
	while i < 1:
		await get_tree().create_timer(0.01).timeout
		i += 0.1
		Printed_dialogue.visible_ratio = i

func _on_link_button_pressed() -> void:
	current_dialogue += 1
	dialogue(current_dialogue)
	pass # Replace with function body.

func _on_detection_body_entered(body: Node3D) -> void:
	if body == Maincharacter:
		Bully_cam.current = true
		emit_signal('detected',true)
		$Dialogue.show()
		dialogue(1)
	pass # Replace with function body.

func done_chatting():
	Bully_cam.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Dialogue.hide()
	$Detection.free()
	emit_signal('start_day')
	emit_signal('detected',false)


func _on_fight_back_pressed() -> void:
	done_chatting()


func _on_escape_pressed() -> void:
	done_chatting()


func _on_accept_pressed() -> void:
	done_chatting()
