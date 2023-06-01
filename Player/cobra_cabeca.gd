extends CharacterBody2D

const vmax = 300
const friction = 600
const accel = 2000

@onready var parent = self.get_parent()

var input = Vector2.ZERO

func _ready():
	if not is_multiplayer_authority(): return
	
	$Area2D/PlayerName.text = "VOCÊ"

func _physics_process(delta):
	if not is_multiplayer_authority():	return
	
	input = get_input()

	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(vmax)
	move_and_slide()

## Recebe input e retorna um Vector2
func get_input():
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	return input.normalized()

## Função de comer a comida
func _on_area_2d_body_entered(body):
	if not is_multiplayer_authority():	return
	
	if (body.is_in_group("comida")):
		parent.add_body(body.peso)
		PlayerData.delete_food.rpc(body.name)
		body.queue_free()
	else:
		print(body.name)
