class_name Interactive_things extends CSGBox3D

@export_enum("Food","Chair","Locker") var Interactive_Name: String
@export_enum("Press 'E' to interact","Press 'F' to interact") var caninteract: String
@onready var thisname: Label3D = $Label3D
@export var cansit = false
func _ready() -> void:
	thisname.text = Interactive_Name
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Ben" and Interactive_Name == "Chair":
		cansit = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Ben" and Interactive_Name == "Chair":
		cansit = false
	pass # Replace with function body.
