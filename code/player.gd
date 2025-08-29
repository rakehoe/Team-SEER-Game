class_name Player extends CharacterBody3D

signal showui
signal medead

var SPEED = 5.0

var Items = preload("res://scenes/Items.tscn")
@onready var bully: Node3D = get_parent().get_node('Bully')
@onready var camera_controller_anchor: Marker3D = $CameraControllerAnchor
@onready var raycast: RayCast3D = $CameraController/Hand
@onready var test_text = $"Main_Ui/top-right-ui/test"
@onready var energy = $"Main_Ui/top-right-ui/Energy"
@onready var energy_label = $"Main_Ui/top-right-ui/Energy/Energy update"
@onready var courage = $"Main_Ui/top-right-ui/Courage"
@onready var courage_label = $"Main_Ui/top-right-ui/Courage/Courage update"
@onready var cam = $CameraController/Camera3D
@onready var instructions = $Main_Ui/Side_Instructions/Look_instruction
@onready var consequence_label = $Instructions/Consequences
@onready var inventory = $Main_Ui/Inventory
@onready var anim = $Ben10_2/Animation
@onready var mainUI :CanvasLayer = get_node("Main_Ui")
var FOOD_ENERGY = {
	"APPLE": 10,
	"BREAD": 5,
	"WATER": 2,
	"ENERGY DRINK": 20
}

var interact = false
var moved = false
var talking = false
var sit = false
var current_max_energy = 100
func _ready() -> void:
	mainUI.hide()
	instructions.hide()
	$Intro.show()
	if bully:
		bully.connect("detected",_on_bully_detected)
		# bully.connect("consequences", _)
	if inventory:
		inventory.connect("eating",_energy_update)

func idle():
	anim.speed_scale = 1
	anim.play('IDLEANIM')
	if sit:
		if energy.value < current_max_energy:
			_energy_update(0.02)
		if Input.is_action_pressed("stand"):
			itemdeletion.hide()
			sit = false


func runfov(on):
	var camfov = 75
	if on and cam.fov < 85:
		cam.fov += 1
	elif !on and cam.fov > camfov:
		cam.fov -=1


func _physics_process(_delta: float) -> void:
	if courage.value <= 0:
		emit_signal('medead')
		return
	if energy.value < 10:
		SPEED = 3
	elif energy.value > 10:
		SPEED = 5
	test_text.text = "sitting: " + str(sit)
	interacting(raycast.is_colliding())
	var input_dir: Vector2

	if sit:
		idle()
		itemdeletion.show()
		itemdeletion.text = 'Press [SPACE] to stand'

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
		runfov(true)

	self.show()
	if direction:
		runfov(false)
		if !moved:
			intro()
			moved = true
		new_velocity = Vector2(direction.x, direction.z) * SPEED
		if anim.current_animation != "RUNANIM" and !sit and !talking:
			anim.play('RUNANIM')
			anim.speed_scale = 0.5
		if Input.is_action_pressed("run") and energy.value > 0 and !sit and !talking:
			anim.speed_scale = 1
			runfov(true)
			_energy_update(-0.05)
			new_velocity = Vector2(direction.x, direction.z) *(SPEED * 1.2)
		elif Input.is_action_pressed("run") and sit:
			idle()

	if !talking and !sit:
		velocity = Vector3(new_velocity.x, velocity.y, new_velocity.y)
		move_and_slide()
		itemdeletion.hide()
	else:
		anim.speed_scale = 1
		anim.play("IDLEANIM")

	#Checking if the player is not moving
	if velocity.is_zero_approx():
		idle()
		if !Input.is_action_pressed("run"):
			runfov(false)

# updating the energy
@onready var energy_timer = $"Main_Ui/top-right-ui/Energy_timer"

func _energy_update(received_energy):
	var t = 1
	energy_timer.start(t)
	if energy.value < current_max_energy || energy.value > 0:
		energy_label.show()
		if received_energy > 0:
			energy_label.text = "+%0.2f Energy" % received_energy
		elif received_energy < 0:
			energy_label.text = "%0.2f Energy" % received_energy
		else:
			energy_label.text = "0.00 Energy"
		energy.value += received_energy
func _energy_timer_timeout() -> void:
	energy_label.hide()

#Checking if you are looking to an object
# E - use and F - pickup
func interacting(cast):
	var target = raycast.get_collider()
	to_interact(target,false)
	
	instructions.hide()
	if cast and target:
		if target.Object_Type != target.ObjectType.CHAIR:
			to_interact(target,true)
		match target.Interactive_Type:
			target.Interactivetype.OBJECT:
				if target.cansit:
					to_interact(target,true)
				if Input.is_action_just_pressed("use"):
					if target.cansit and !sit:
						sit = true
						self.position.y += 1
				else:
					to_interact(target,false)
			target.Interactivetype.FOOD:
				if Input.is_action_just_pressed("pickup"):
					var food_str = target.FoodType.keys()[target.Food_Type].replace("_"," ")
					var energy_value = FOOD_ENERGY.get(food_str, 0)
					update_inv(food_str,target,energy_value)
					pass
			_:
				pass
	else:
		instructions.hide()

func update_inv(new_item,freethis,evalue):
	var invcontent = inventory.inv_content
	for i in invcontent[0].size():
		if invcontent[0][i] == "":
			invcontent[1][i] = evalue
			invcontent[0][i] = new_item
			freethis.free()
			return

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
		
	emit_signal('showui')
	$Intro.free()
	mainUI.show()

func _on_bully_detected(ui_hide) -> void:
	if ui_hide:
		mainUI.hide()
		talking = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif !ui_hide:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		talking = false
		mainUI.show()
	pass # Replace with function body.

func _on_bully_start_day(min_req, received) -> void:
	var consequence
	match min_req:
		50:
			consequence = "fight back"
			pass
		25:
			consequence = "escape"
			pass
	if courage.value < min_req:
		consequence_label.show()
		consequence_label.text = "You don't have enough courage to " + consequence
		await get_tree().create_timer(2).timeout
		consequence_label.text = "%1d will be deducted to your energy for the entire day." % received
		await get_tree().create_timer(3).timeout
		consequence_label.hide()
		current_max_energy -= received
		_energy_update(-received)
	if courage.value > min_req:
		consequence_label.show()
		consequence_label.text = "You beat the bully"
		await get_tree().create_timer(2).timeout
		consequence_label.hide()
		
	pass # Replace with function body.


@onready var thingslabel = $CameraController/Realhand/Things/Things_Label
@onready var iteminstruction = $Main_Ui/Side_Instructions/Item_instruction
@onready var itemdeletion = $Main_Ui/Side_Instructions/Item_deletion
@onready var droppoint = $Droppoint


func _on_inventory_inv_key(key_press,thingsLabel) -> void:
	if key_press < 10 and thingsLabel != "":
		iteminstruction.show()
		itemdeletion.show()
		iteminstruction.text = 'Press [L Mouse] to use this item'
		itemdeletion.text = 'Press [Q] to drop'
		thingslabel.text = thingsLabel
	elif key_press == 20 and thingsLabel != "":
		var instance = Items.instantiate()
		instance.Interactive_Type = instance.Interactivetype.FOOD
		instance.name = "Thrown"
		instance.drop(thingsLabel)
		instance.set_global_transform(droppoint.get_global_transform_interpolated())
		get_parent().get_parent().add_child(instance)
	else:
		itemdeletion.hide()
		iteminstruction.hide()
		
	pass # Replace with function body.


func _on_map_stop_player(talk) -> void:
	talking = talk
	pass # Replace with function body.
