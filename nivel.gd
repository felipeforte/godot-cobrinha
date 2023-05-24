extends Node2D

const width = 1000
const height = 600
const comida = preload("res://comida.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var nova_comida = comida.instantiate()
	nova_comida.peso = randi_range(-1, 1)
	
	#TODO: melhorar essa logica
	if nova_comida.peso == 0:
		nova_comida.peso = 1
	
	nova_comida.position.x = randi() % width
	nova_comida.position.y = randi() % height
	nova_comida.setLabelText(nova_comida.peso)
	#print(nova_comida)
	add_child(nova_comida)
