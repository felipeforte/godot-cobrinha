extends RigidBody2D

var peso

var comidinhaPositiva := preload("res://comida.png")
var comidinhaNegativa := preload("res://comida.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(peso)
	print(peso < 0)
	
	if peso < 0:
		$Sprite2D.self_modulate = Color(234, 82, 111, 1.0)
	else:
		$Sprite2D.self_modulate = Color(125, 226, 209, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if peso < 0:
	#else:
	#		$Sprite2D.modulate = Color(35, 181, 211)
	pass
	
func setLabelText(text):
	$Label.text = str(text)


