extends CSGBox3D

@export_enum("Food","Chair","Locker") var Interactive_Name: String
@export_enum("Press 'E' to interact","Press 'F' to interact") var caninteract: String

@onready var instruct: Label3D = $Notif


func _ready() -> void:
	instruct.text = caninteract


func _on_area_3d_body_entered(body:Node3D) -> void:
	if body.name == "Ben":
		$Notif.show()
	pass # Replace with function body.


func _on_area_3d_body_exited(body:Node3D) -> void:
	if body.name == "Ben":
		$Notif.hide()
	pass # Replace with function body.
