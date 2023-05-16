extends CharacterBody2D

@onready var body = preload("res://cobra_corpo.tscn")
@onready var head = $cobra_cabeça
var bodies: Array = []

func _physics_process(delta):
	if Input.is_action_just_pressed("debug_new"):
		add_body()

func add_body():
	var body_new = body.instantiate()
	add_child(body_new)
	if bodies.size() == 0:
		body_new.parent = head
	else:
		body_new.parent = bodies.back()
	bodies.append(body_new)
