extends RigidBody3D

enum FoodType { NONE, APPLE, BREAD, ENERGY_DRINK, WATER }
enum Interactivetype { NONE, FOOD, OBJECT }
enum ObjectType { NONE, CHAIR, LOCKER}

@onready var Object_Type: ObjectType = ObjectType.NONE
@onready var Interactive_Type:Interactivetype = Interactivetype.FOOD
@onready var Food_Type: FoodType = FoodType.NONE

@onready var Apple = $Apple
@onready var Bread = $Bread
@onready var Energy_Drink = $Energy_Drink
@onready var Water = $Water
var spawn = true
var caninteract: String = "Press 'F' to interact"
var type

func drop(whatfood):
	spawn = false
	for i in FoodType.keys().size():
		if whatfood == FoodType.keys()[i].replace("_"," "):
			type = i

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var foodchosen := FoodType.keys()
	var idx := rng.randi_range(1, foodchosen.size() - 1)
	if spawn:
		type = idx
		Food_Type = type
	else:
		Food_Type = type
	match Food_Type:
		1:
			Apple.show()
			Apple.disabled = false
		2:
			Bread.show()
			Bread.disabled = false
		3:
			Energy_Drink.show()
			Energy_Drink.disabled = false
		4:
			Water.show()
			Water.disabled = false
		_:
			pass
