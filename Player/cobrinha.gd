extends CharacterBody2D

const MAX_VELOCITY = 300
const FRICTION = 600
const ACCELERATION = 2000

var bodies: Array = []

var INPUT = Vector2.ZERO

var head
var body

func _enter_tree():
	var id = PlayerData.identifier	
	set_multiplayer_authority(str(id).to_int())	
	print("Enter: ", id)

func _ready():
	if not is_multiplayer_authority():	return
	
	head = $cabeca
	body = $corpo

func _physics_process(delta):
	if not is_multiplayer_authority():	return
	
	INPUT = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if INPUT == Vector2.ZERO:
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (INPUT * ACCELERATION * delta)
		velocity = velocity.limit_length(MAX_VELOCITY)
	
	move_and_slide()

func add_body(pesoComida):
	if not is_multiplayer_authority():	return
	
	var body_new = body.instantiate()
	
	if bodies.size() == 0:
		body_new.parent = head
	else:
		body_new.parent = bodies.back()
	body_new.position = body_new.parent.position
	add_child(body_new)
	bodies.append(body_new)

func _on_area_2d_2_body_entered(body):
	if (body.is_in_group("comida")):
		add_body(body.peso)
		body.queue_free()
	else:
		print(body.name)
