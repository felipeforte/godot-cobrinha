extends Node2D

const width = 1000
const height = 600

@onready var timer : Timer = $Timer
@onready var main_menu = $CanvasLayer/MainMenu
@onready var join_button = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer2/HBoxContainer/JoinButton
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer2/HBoxContainer/AddressEntry

const comida = preload("res://Components/Food/comida.tscn")
const Player = preload("res://Player/cobrinha.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

var currentPlayer

func _ready():
	Events.connect("food_added", _on_food_added)

func _on_timer_timeout():
	generate_food.rpc()

func _on_food_added(food):
	spawn_food(food)

@rpc("call_remote")
func generate_food():
	var nova_comida = comida.instantiate()
	nova_comida.peso = randi_range(-1, 1)
	
	if nova_comida.peso == 0:
		nova_comida.peso = 1
	
	nova_comida.name = "comida_%s" % Utils.generate_random_string(10)
	nova_comida.position.x = randi() % width
	nova_comida.position.y = randi() % height
	nova_comida.setLabelText(nova_comida.peso)
	
	PlayerData.universalFoods.append(nova_comida)
	
	Events.emit_signal("food_add", nova_comida)
	
	print(nova_comida.name)

func spawn_food(food):
	add_child(food)

func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	#upnp_setup()


func _on_join_button_pressed():
	var host = address_entry.text
	
	if Utils.is_valid_ip(host):
		main_menu.hide()
		enet_peer.create_client(host, PORT)
		multiplayer.multiplayer_peer = enet_peer
		add_player(multiplayer.get_unique_id())

func _on_quit_button_pressed():
	get_tree().quit()

func add_player(peer_id):
	currentPlayer = Player.instantiate()
	currentPlayer.name = str(peer_id)
	currentPlayer.identifier = str(peer_id)
	add_child(currentPlayer)
	print("Entrou na sala: ", currentPlayer.identifier)
	
	print(getConnectedPlayers())

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	
	if player:
		player.queue_free()

func _on_address_entry_text_changed(new_text: String) -> void:
	if Utils.is_valid_ip(new_text):
		join_button.disabled = false
	else:
		join_button.disabled = true

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
	"UPNP Discover Failed! Error %s" % discover_result)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
	"UPNP Invalid Gateway!")
	
	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
	"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address()[randi() % 10])

func getConnectedPlayers() -> Array:
	var players = []
	var peerCount = enet_peer
	
#	for i in range(peerCount):
#		var peer = multiplayer.get_peer(i)
#		if peer.is_connected_to_host(): players.append(peer.get_packet_ip())
	
	return players
