extends CharacterBody2D

var parent: CharacterBody2D = null
var novo = true

func _physics_process(delta):
	follow_parent()

func follow_parent():
	if (abs(position.x-parent.position.x)<15 && abs(position.y-parent.position.y)<15):
		pass
	else:
		self.global_transform.origin = lerp(self.global_transform.origin, parent.global_transform.origin, get_physics_process_delta_time()*10)
		self.rotation_degrees = lerp(self.rotation_degrees, parent.rotation_degrees, get_physics_process_delta_time()*7.5)
