extends CharacterBody2D

const MAX_VELOCITY = 300
const FRICTION = 600
const ACCELERATION = 2000

var bodies: Array = []

var INPUT = Vector2.ZERO

var identifier

@onready var head := $cobra_cabeca
@onready var body := preload("res://Player/cobra_corpo.tscn")
@onready var multiplayer_sync := $MultiplayerSynchronizer

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())	
	print("Enter: ", name)

func _physics_process(delta):
	if not is_multiplayer_authority():	return

func add_body(pesoComida):
	if not is_multiplayer_authority():	return
	
	var body_temp = preload("res://Player/cobra_corpo.tscn")
	var body_new = body_temp.instantiate()
	
	if bodies.size() == 0:
		print("Adiciona CABECA***************")
		body_new.parent = head
	else:
		body_new.parent = bodies.back()
		print("Adiciona CORPO***************")
	
	body_new.position = body_new.parent.position
	bodies.append(body_new)
	$Node.add_child(body_new)
