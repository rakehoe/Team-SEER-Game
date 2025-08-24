class_name Player extends CharacterBody3D

signal showui

const SPEED = 5.0

@onready var camera_controller_anchor: Marker3D = $CameraControllerAnchor
@onready var raycast: RayCast3D = $CameraController/Hand
@onready var test_text = $"Main_Ui/top-right-ui/test"
@onready var energy = $"Main_Ui/top-right-ui/Energy"
@onready var cam = $CameraController/Camera3D
@onready var instructions = $Main_Ui/Instructions/Label

var interact = false
var moved = false
var talking = false
var sit = false

func _ready() -> void:
	$Main_Ui.hide()
	$Intro.show()

func idle():
	if sit:
		energy.value += 0.02
		if Input.is_action_pressed("stand"):
			sit = false

func _physics_process(_delta: float) -> void:
	test_text.text = "sitting: " + str(sit)
	var camfov = 75
	idle()
	interacting(raycast.is_colliding())
	var input_dir: Vector2
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	# WASD movement vector
	if is_on_floor():
		input_dir= Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# super basic locomotion
	var new_velocity = Vector2.ZERO
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	if Input.is_action_pressed("run") and energy.value > 10 and !sit:
		cam.fov = camfov+25

	self.show()
	if direction:
		if !moved:

			intro()
			moved = true
		cam.fov = camfov
		new_velocity = Vector2(direction.x, direction.z) * SPEED
		if Input.is_action_pressed("run") and energy.value > 10 and !sit:
			cam.fov = camfov+25
			energy.value -= 0.05
			new_velocity = Vector2(direction.x, direction.z) *(SPEED * 1.2)

	if !talking:
		if !sit:
			velocity = Vector3(new_velocity.x, velocity.y, new_velocity.y)
			move_and_slide()
	
	
#	Checking if the player is not moving
	if velocity.is_zero_approx():
		idle()
		if !Input.is_action_pressed("run"):
			cam.fov = camfov
	


#Checking if you are looking to an object
# E - use and F - pickup
func interacting(cast):
	var target = raycast.get_collider()
	to_interact(target,false)
	instructions.hide()
	if cast and target:
		match target.caninteract:
			"Press 'E' to interact":
				to_interact(target,true)
				if Input.is_action_just_pressed("use"):
					target.free()
			"Press 'F' to interact":
				to_interact(target,true)
				if Input.is_action_just_pressed("pickup"):
					if target.Interactive_Name == "Chair" and !sit:
						var chairpos = Vector3(target.position)
						sit = true
						self.position = chairpos
					pass
			_:
				pass
	else:
		instructions.hide()

func to_interact(a,b):
	if a != null:
		instructions.text = a.caninteract
	if b:
		instructions.show()

#swithing ui
func intro():
	var i = 10
	while i > 0:
		await get_tree().create_timer(0.1).timeout
		$Intro/Instruction.modulate.a -= 0.1
		i -= 1
		
	emit_signal('showui',true)
	$Intro.free()
	$Main_Ui.show()

func _on_bully_detected(ui_hide) -> void:
	if ui_hide:
		talking = true
		$Main_Ui.hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif !ui_hide:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		talking = false
		$Main_Ui.show()
	pass # Replace with function body.
