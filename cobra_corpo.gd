extends CharacterBody2D

var parent: CharacterBody2D = null

func _physics_process(delta):
	follow_parent()

func follow_parent():
	self.global_transform.origin = lerp(self.global_transform.origin,parent.global_transform.origin,get_physics_process_delta_time()*8)
	self.rotation_degrees = lerp(self.rotation_degrees,parent.rotation_degrees,get_physics_process_delta_time()*5)
