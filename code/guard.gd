extends CharacterBody3D

signal gone

@onready var nav:NavigationAgent3D = $NavigationAgent3D
@onready var anim = $Root/Animation
@onready var parent_path
@onready var outofsight:Timer = $Timer

var mainnav:PathFollow3D
var player
var speed = 4.5
var gravity = 14
var PlayerDetected = false

func _ready():
	mainnav = get_parent()

func _process(delta):
	var next_location = nav.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	if not PlayerDetected:
		mainnav.progress += speed * delta
		move_and_slide()
	elif PlayerDetected:
		nav.target_position = player.global_position
		look_at(player.global_position)
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()

func _on_flashlight_body_entered(body:Node3D) -> void:
	if body.name == "Ben":
		outofsight.paused = true
		PlayerDetected = true
		player = body
		speed = 5

func _on_flashlight_body_exited(body: Node3D) -> void:
	if body.name == "Ben":
		outofsight.paused = false
		outofsight.start(3)
	pass # Replace with function body.


func _out_of_sight() -> void:
	emit_signal('gone')
	await get_tree().create_timer(0.5).timeout
	self.free()
	pass # Replace with function body.


func _player_tagged() -> void:
	if player.courage.value > 0:
		player.courage.value -= 5
	pass # Replace with function body.
