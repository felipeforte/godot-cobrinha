extends CharacterBody2D

const vmax = 300
const friction = 600
const accel = 2500

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
	
func get_input():
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	return input.normalized()


