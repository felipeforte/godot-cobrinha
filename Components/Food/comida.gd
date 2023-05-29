extends RigidBody2D

var peso = 0

const comidinhaPositiva := preload("res://Assets/Images/comida.png")
const comidinhaNegativa := preload("res://Assets/Images/comida_negativa.png")

@onready var sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():	
	if peso < 0:
		sprite.texture = comidinhaNegativa
	else:
		sprite.texture = comidinhaPositiva

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setLabelText(text):
	$Label.text = str(text)


