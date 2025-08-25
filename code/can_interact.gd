@tool
class_name Interactive_things extends CSGBox3D

enum Interactivetype { NONE, FOOD, OBJECT }
enum FoodType { NONE, APPLE, BREAD, BANANA, WATER, CHIPS, ENERGY_DRINK}
enum ObjectType { NONE, CHAIR, LOCKER}

@export var Interactive_Type: Interactivetype = Interactivetype.NONE
@export var Food_Type: FoodType = FoodType.NONE
@export var Object_Type: ObjectType = ObjectType.NONE

var caninteract: String
@onready var thisname: Label3D = $Label3D
@export var cansit = false

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta):
	match Interactive_Type:
		Interactivetype.FOOD:
			thisname.text = FoodType.keys()[Food_Type].replace("_", " ")
			caninteract = "Press 'F' to interact"
		Interactivetype.OBJECT:
			thisname.text = ObjectType.keys()[Object_Type]
			caninteract = "Press 'E' to interact"


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Ben" and Object_Type == ObjectType.CHAIR:
		cansit = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Ben" and Object_Type == ObjectType.CHAIR:
		cansit = false
	pass # Replace with function body.
