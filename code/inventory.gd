extends HBoxContainer

var inv_content = {}
var key_active: int = 10

signal inv_key
signal eating

func _ready():
	inv_content[0] = ["", "", "", "", ""]
	inv_content[1] = [0, 0, 0, 0, 0]
	_default_name()

func _process(_delta):
	for i in inv_content[0].size():
		if inv_content[0][i] != "":
			get_child(i).text = inv_content[0][i]

	_default_name()
	if Input.is_action_just_pressed("throw") and key_active < 10:
		emit_signal('inv_key',20,inv_content[0][key_active])
		inv_remove()
	if Input.is_action_just_pressed("consume") and key_active < 10:
		eat(inv_content[1][key_active])
		inv_remove()
	for i in range(1,6):
		if Input.is_action_just_pressed("key_%d" % i):
			match i:
				1: _key_active(i-1)
				2: _key_active(i-1)
				3: _key_active(i-1)
				4: _key_active(i-1)
				5: _key_active(i-1)

func eat(energy_value):
	var Myplayer = get_parent().get_parent()
	if energy_value != 0:
		if Myplayer.energy.value < Myplayer.current_max_energy:
			emit_signal('eating',energy_value)
	pass

func inv_remove():
	inv_content[0][key_active] = ""
	inv_content[1][key_active] = 0
	_key_active(key_active)


func _key_active(press):
	emit_signal('inv_key',press,inv_content[0][press])
	if key_active == press:
		get_child(press).disabled = true
		key_active = 10
		emit_signal('inv_key',10,inv_content[0][press])
	else:
		key_active = press
		get_child(press).disabled = false
	for i in 5:
		if i != (press):
			get_child(i).disabled = true

func _default_name():
	for i in inv_content[0].size():
		if inv_content[0][i] == "":
			get_child(i).text = get_child(i).name
