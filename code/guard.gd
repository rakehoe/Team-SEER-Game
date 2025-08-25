extends CharacterBody3D

@onready var nav = $NavigationAgent3D
var speed = 4.2
var gravity = 9.8
func _process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = -2

	var next_location = nav.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * speed

	velocity = velocity.move_toward(new_velocity, 0.25)
	move_and_slide()

func target_position(Ben):
	nav.target_position = Ben
