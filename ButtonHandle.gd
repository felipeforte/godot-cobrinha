extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventKey:
		print("xupteta")
		if event.pressed and event.get_keycode_with_modifiers() == KEY_SPACE:
			print("apertei")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
