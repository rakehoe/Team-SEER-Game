@tool
class_name Interactive_things extends CSGBox3D

enum Interactivetype { NONE, FOOD, OBJECT, ANSWERKEY }
enum FoodType { NONE, APPLE, BREAD, BANANA, WATER, CHIPS, ENERGY_DRINK}
enum ObjectType { NONE, CHAIR, SAFE}

@export var Interactive_Type: Interactivetype = Interactivetype.NONE
@export var Food_Type: FoodType = FoodType.NONE
@export var Object_Type: ObjectType = ObjectType.NONE

var caninteract: String
@onready var thisname: Label3D
@export var cansit = false

func _ready() -> void:
	if Object_Type != ObjectType.SAFE:
		thisname = $Label3D
	if Interactive_Type == Interactivetype.FOOD:
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		var foodchosen := FoodType.keys()
		var idx := rng.randi_range(1, foodchosen.size() - 1)
		Food_Type = idx
	pass # Replace with function body.

func _process(_delta):
	if Object_Type == ObjectType.SAFE:
		caninteract = "Press [ E ] to interact"
	match Interactive_Type:
		Interactivetype.FOOD:
			thisname.text = FoodType.keys()[Food_Type].replace("_", " ")
			caninteract = "Press [ F ] to interact"
		Interactivetype.OBJECT:
			caninteract = "Press [ E ] to interact"
			if Object_Type != ObjectType.SAFE:
				thisname.text = ObjectType.keys()[Object_Type]
				return
		Interactivetype.ANSWERKEY:
			caninteract = "Press [ E ] to pick up"
			pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Ben" and Object_Type == ObjectType.CHAIR:
		cansit = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Ben" and Object_Type == ObjectType.CHAIR:
		cansit = false
	pass # Replace with function body.
