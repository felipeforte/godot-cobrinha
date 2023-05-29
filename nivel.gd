extends Node2D

const width = 1000
const height = 600

var comida = preload("res://Components/Food/comida.tscn")

@onready var timer : Timer = $Timer

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://Player/cobrinha.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	timer.stop()

func _on_timer_timeout():
	var nova_comida = comida.instantiate()
	nova_comida.peso = randi_range(-1, 1)
	
	if nova_comida.peso == 0:
		nova_comida.peso = 1
	
	nova_comida.position.x = randi() % width
	nova_comida.position.y = randi() % height
	nova_comida.setLabelText(nova_comida.peso)
	add_child(nova_comida)


func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	
	#timer.start()


func _on_join_button_pressed():
	main_menu.hide()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	add_player(multiplayer.get_unique_id())

func _on_quit_button_pressed():
	get_tree().quit()

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.identifier = str(peer_id)
	add_child(player)
	print("Entrou na sala: ", player.identifier)
