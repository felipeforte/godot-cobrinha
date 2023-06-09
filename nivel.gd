extends Node2D

const width = 1000
const height = 600

@onready var timer : Timer = $Timer
@onready var timerBatalha : Timer = $TimerBatalha


@onready var main_menu = $CanvasLayer/MainMenu
@onready var join_button = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer2/HBoxContainer/JoinButton
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer2/HBoxContainer/AddressEntry

var simultaneous_scene = preload("res://Batalha.tscn").instantiate()

const comida = preload("res://Components/Food/comida.tscn")
const Player: = preload("res://Player/cobrinha.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

var partida : bool

var currentPlayer

func _ready():
	timerBatalha.start()
	pass

func _on_timer_batalha_timeout():
	if multiplayer.is_server() and multiplayer.get_peers().size() > 0:
		montaCenario()

func _on_timer_timeout():
	if multiplayer.is_server() and multiplayer.get_peers().size() > 0:
		generate_food()

@rpc("call_local")
func spawn_food(foodName, positionX, positionY, foodHeight):
	if not has_node(foodName):
		var nova_comida = comida.instantiate()
		nova_comida.name = foodName
		nova_comida.position.x = positionX
		nova_comida.position.y = positionY
		nova_comida.peso = foodHeight
		nova_comida.setLabelText(foodHeight)
		add_child(nova_comida)
#		print("Spawn food to: %s" % multiplayer.get_unique_id())

func generate_food():
	var foodName = "comida_%s" % Utils.generate_random_string(10)
	var positionX = randi() % width
	var positionY = randi() % height
	var foodHeight = randi_range(-1, 1)
	
	if foodHeight == 0:
		foodHeight = 1
	
	spawn_food.rpc(foodName, positionX, positionY, foodHeight)
	
	for peer_id in multiplayer.get_peers():
		spawn_food.rpc_id(peer_id, foodName, positionX, positionY, foodHeight)

func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	#autodiscover servers on lan
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
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

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
	
#	print("Success! Join Address: %s" % upnp.query_external_address()[randi() % 10])
	
func montaCenario():
	var calculoGerado = Utils.generate_calc()
	
	var numero1 = calculoGerado[0]
	var numero2 = calculoGerado[1]
	var simbolo = calculoGerado[2]
	var resultado = calculoGerado[3]
	#primeiro gera o do servidor
	_add_a_scene_manually(numero1, numero2, simbolo, resultado)
	
	for peer_id in multiplayer.get_peers():
		_add_a_scene_manually.rpc_id(peer_id, numero1, numero2, simbolo, resultado)

@rpc("any_peer")
func _add_a_scene_manually(numero1, numero2, simbolo, resultado):
	simultaneous_scene.numero1 = numero1
	simultaneous_scene.numero2 = numero2
	simultaneous_scene.simbolo = simbolo
	simultaneous_scene.resultado = resultado
	get_tree().paused = true
	get_tree().get_root().add_child(simultaneous_scene)
	var opcoes = []
	for n in 4:
		opcoes.append(resultado)
		var random = randi() % resultado
		while (opcoes.has(random)):
			if resultado > -4 && resultado < 4:
				if resultado < 0:
					random = randi_range(-4,0)
				else:
					random = randi_range(0,4)
			else:
				random = randi() % resultado
		opcoes.append(random)
		simultaneous_scene.buttons[n].get_child(0).text = str(random)
	var btnCorrect = randi() % 4
	simultaneous_scene.buttons[btnCorrect].get_child(0).text = str(resultado)
	simultaneous_scene.btnCorrect = btnCorrect
