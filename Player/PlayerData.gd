extends Node

var identifier = null
var bodies: Array = []

var universalFoods: Array = []

func _ready():
	if not is_multiplayer_authority():	return

@rpc("any_peer")
func delete_food(foodName):
	var nodePath = NodePath("/root/nivel/%s" % foodName)
	if not has_node(nodePath): return
	
	print('Delete from node a food %s' % foodName)
	var nodeToRemove = get_node("/root/nivel/%s" % foodName)
	if nodeToRemove:
		nodeToRemove.queue_free()

@rpc("any_peer")
func add_body(name, size):
	var cobrinha = get_node("/root/nivel/%s" % name)
	
	while (size != cobrinha.bodies.size()):
		if cobrinha.bodies.size() < size:
			var body_new = preload("res://Player/cobra_corpo.tscn").instantiate()
			if cobrinha.bodies.size() == 0:
				body_new.parent = cobrinha.get_child(0)
			else:
				body_new.parent = cobrinha.bodies.back()
			body_new.position = body_new.parent.position
			cobrinha.bodies.append(body_new)
			cobrinha.add_child(body_new)
		elif cobrinha.bodies.size() > size:
			cobrinha.remove_child(cobrinha.bodies.pop_back())
	
#	if bodies.size() == 0:
#		body_new.parent = head
#	else:
#		body_new.parent = bodies.back()
#
#	
#	bodies.append(body_new)
#	$Node.add_child(body_new)
