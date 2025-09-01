@tool
class_name Interactive_things extends CSGBox3D

enum Interactivetype { NONE, FOOD, OBJECT, ANSWERKEY }
enum FoodType { NONE, APPLE, BREAD, BANANA, WATER, CHIPS, ENERGY_DRINK}
enum ObjectType { NONE, CHAIR, SAFE, DOOR }

@export var Interactive_Type: Interactivetype = Interactivetype.NONE
@export var Food_Type: FoodType = FoodType.NONE
@export var Object_Type: ObjectType = ObjectType.NONE

var caninteract: String
@onready var thisname: Label3D

func _ready() -> void:
	match Object_Type:
		ObjectType.SAFE:
			caninteract = "Press [ E ] to interact"
		ObjectType.DOOR:
			thisname = get_node('Doorinst')
			thisname.hide()
			thisname.text = "Press [ E ] to interact"
		ObjectType.CHAIR:
			thisname = get_node("Label3D")
			caninteract = "Press [ E ] to interact"
			thisname.text = ObjectType.keys()[Object_Type]

	if Interactive_Type == Interactivetype.ANSWERKEY:
		caninteract = "Press [ E ] to pick up"
