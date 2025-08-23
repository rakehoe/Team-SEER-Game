class_name Interactive_things extends CSGBox3D

@export_enum("Food","Chair","Locker") var Interactive_Name: String
@export_enum("Press 'E' to interact","Press 'F' to interact") var caninteract: String
@onready var thisname: Label3D = $Label3D

func _ready() -> void:
	thisname.text = Interactive_Name

	pass # Replace with function body.
