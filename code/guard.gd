extends CharacterBody3D

signal gone

@export var Rest_Timer:float = 1.0
@export var Damage:int = 5
@onready var nav:NavigationAgent3D = $NavigationAgent3D
@onready var anim = $Root/Animation
@onready var parent_path
@onready var outofsight:Timer = $Timer
@onready var warninganim:AnimationPlayer = $WarningAnim
@onready var warningtext:Label = $Warning/ColorRect5/Label

var outofrange = false
var warningtxt = ["warning you have been detected", "you have been unnoticed"]
var warningclr = ['#8f242cff','#248f32ff']
var mainnav:PathFollow3D
var player
var speed = 3
var gravity = 14
var PlayerDetected = false
var resting = false

func _ready():
	$Warning.hide()
	mainnav = get_parent()

func _process(delta):
	var next_location = nav.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	if not PlayerDetected:
		warninganim.stop()
		$Warning.hide()
		if not resting:
			mainnav.progress += speed * delta
			move_and_slide()
	elif PlayerDetected:
		nav.target_position = player.global_position
		if outofrange:
			changecr(warningclr[1])
			warningtext.text = warningtxt[1]
		elif !outofrange:
			changecr(warningclr[0])
			warningtext.text = warningtxt[0]

		$Warning.show()
		if !warninganim.is_playing():
			warninganim.play('Warning')
		look_at(player.global_position)
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()

func _on_flashlight_body_entered(body:Node3D) -> void:
	if body.name == "Ben":
		outofrange = false
		outofsight.paused = true
		PlayerDetected = true
		player = body
		speed = 5

func _on_flashlight_body_exited(body: Node3D) -> void:
	if body.name == "Ben":
		outofrange = true
		outofsight.paused = false
		outofsight.start(3)
	pass # Replace with function body.


func _out_of_sight() -> void:
	emit_signal('gone',true)
	await get_tree().create_timer(0.5).timeout
	self.free()
	pass # Replace with function body.


func _player_tagged() -> void:
	resting = true
	PlayerDetected = false
	anim.play('IDLEANIM')
	if player.courage.value > 0:
		player.courage.value -= Damage
	await get_tree().create_timer(Rest_Timer).timeout
	PlayerDetected = true
	anim.play('RUNANIM')
	pass # Replace with function body.


func changecr(mycolor):
	for i in $Warning.get_child_count():
		$Warning.get_child(i).color = mycolor
