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
