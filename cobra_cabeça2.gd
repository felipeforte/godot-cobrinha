extends CharacterBody2D

const vmax = 300
const friction = 600
const accel = 2000

@onready var parent = self.get_parent()

var input = Vector2.ZERO


func _physics_process(delta):
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
	input.x = Input.get_axis("p2_left", "p2_right")
	input.y = Input.get_axis("p2_up", "p2_down")
	return input.normalized()



## Função de comer a comida
func _on_area_2d_body_entered(body):
	if (body.is_in_group("comida")):
		parent.add_body()
		body.queue_free()
	else:
		#print(body)
		pass
