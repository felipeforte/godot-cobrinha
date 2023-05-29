extends CharacterBody2D

const MAX_VELOCITY = 300
const FRICTION = 600
const ACCELERATION = 2000

var bodies: Array = []

var INPUT 

var identifier

var head
var body

func _enter_tree():
	if identifier != null:
		set_multiplayer_authority(str(identifier).to_int())	
		print("Enter: ", identifier)
		INPUT = Vector2.ZERO
		head = $cabeca
		body = $corpo
		add_body(0)

func _ready():
	if not is_multiplayer_authority():	return


func _physics_process(delta):
	follow_parent()
	
	INPUT = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if INPUT == Vector2.ZERO:
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (INPUT * ACCELERATION * delta)
		velocity = velocity.limit_length(MAX_VELOCITY)
	
	if not is_multiplayer_authority():	return
	
	move_and_slide()

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
	add_child(body_new)

func _on_area_2d_2_body_entered(body):
	if not is_multiplayer_authority():	return
	
	if (body.is_in_group("comida")):
		add_body(body.peso)
		body.queue_free()
	else:
		print(body.name)

func follow_parent():
	if (abs(position.x-self.position.x)<15 && abs(position.y-self.position.y)<15):
		pass
	else:
		body.global_transform.origin = lerp(body.global_transform.origin, self.global_transform.origin, get_physics_process_delta_time()*10)
		body.rotation_degrees = lerp(body.rotation_degrees, self.rotation_degrees, get_physics_process_delta_time()*7.5)

