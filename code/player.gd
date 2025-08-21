class_name Player extends CharacterBody3D

signal snacks
signal pointed
signal showui

const SPEED = 5.0

@onready var camera_controller_anchor: Marker3D = $CameraControllerAnchor
@onready var raycast: RayCast3D = $CameraController/RayCast3D
@onready var test_text = $Main_Ui/test
@onready var energy = $Main_Ui/Energy
@onready var cam = $CameraController/Camera3D
var moved = true
var talking = false

func _ready() -> void:
	$Main_Ui.hide()
	$Intro.show()
	test_text.text = "Speed: " + str(SPEED)

func idle():
	energy.value += 0.02

func _physics_process(_delta: float) -> void:
	var camfov = 75
	
	interacting(raycast.is_colliding())
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta
	
	# WASD movement vector
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# super basic locomotion
	var new_velocity = Vector2.ZERO
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	
	if direction and !talking:
		if moved:
			intro()
			moved = false
		cam.fov = camfov
		new_velocity = Vector2(direction.x, direction.z) * SPEED
		if Input.is_action_pressed("run") and energy.value != 0:
			cam.fov = camfov+25
			energy.value -= 0.05
			new_velocity = Vector2(direction.x, direction.z) *(SPEED * 1.2)
	velocity = Vector3(new_velocity.x, velocity.y, new_velocity.y)
	move_and_slide()
	
#	Checking if the player is not moving
	if velocity.is_zero_approx():
		idle()
		cam.fov = camfov
	


#Checking if you are looking to an object
func interacting(cast):
	var hit = cast
	if hit:
		var target = raycast.get_collider()
		if target.Interactive_Name == "Snacks":
			emit_signal('snacks', true)
			emit_signal('pointed', target)
			if Input.is_action_just_pressed("interact") and energy.value < energy.max_value:
				target.free()
				energy.value += 25
			elif Input.is_action_just_pressed("interact"):
				test_text.text = "Full energy"
#	Need fixing (still sending events because it's in the _physics_process)
	else:
		emit_signal('snacks', false)
		return


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
	elif !ui_hide:
		talking = false
		$Main_Ui.show()
	pass # Replace with function body.
