extends Node

const serial_res = NodePath("res://bin/gdserial.gdns")

#var serial_port = serial_res.new()
#var serial_port

enum CONNECTION_TYPES {
	SERIAL,
	WIFI,
	BLUETHOOT
}

var joystick_connected = false
var joystick_connection_type = CONNECTION_TYPES.SERIAL

var command = ""

var websocketClient
var websocketConnected = false
const websocketHostIP = ""
const websocketPort = 80

func _ready():
#	if serial_res.new():
#		serial_port = serial_res.new()
		
	#joystick_connected = serial_port.open_port('COM5', 115200)
	
	#websocketClient = StreamPeerTCP.new()
	#websocketClient.set_no_delay(true) 
	#websocketClient.connect_to_host(websocketHostIP, websocketPort)
	#if(websocketClient.is_connected_to_host()):
	#	joystick_connected = true
	#	joystick_connection_type = CONNECTION_TYPES.WIFI
	
	print('Joystick:connected -> ', joystick_connected)
	print('Joystick:connected_by -> ', joystick_connection_type)
	
	if joystick_connected:
		send_command("CONNECT")

func _process(delta):
	if joystick_connected:
		var message
		
#		if joystick_connection_type == CONNECTION_TYPES.SERIAL:
#			message = serial_port.read_text()
#		elif joystick_connection_type == CONNECTION_TYPES.WIFI and websocketClient.is_connected_to_host():
			#while websocketClient.get_available_bytes() > 0:
#			message = websocketClient.get_utf8_string(websocketClient.get_available_bytes())
		
		if message.length() > 0:
			for i in message:
				if i == '\n':
					_command_interpreter(command)
					command = ''
				else:
					command = command + i

func send_command(command):
	if joystick_connected:
		print("Joystick:send_command -> ", command)
#		serial_port.write_text(command + '\n')

func _command_interpreter(command):
	var action = command.split(':')
	
	#print(command)
	
	if action[0] == 'BTN':
		if action[1] == 'A':
			if action[2] == 'PRESSED':
				Input.action_press("verde")
			elif action[2] == 'RELEASED':
				Input.action_release("verde")
			
		if action[1] == 'Y':
			if action[2] == 'PRESSED':
				Input.action_press("amarelo")
			elif action[2] == 'RELEASED':
				Input.action_release("amarelo")
			
		if action[1] == 'X':
			if action[2] == 'PRESSED':
				Input.action_press("azul")
			elif action[2] == 'RELEASED':
				Input.action_release("azul")
			
		if action[1] == 'B':
			if action[2] == 'PRESSED':
				Input.action_press("vermelho")
			elif action[2] == 'RELEASED':
				Input.action_release("vermelho")
		
	elif action[0] == 'AXIS':
		if action[1] == 'X':
			if int(action[2]) > 0:
				Input.action_press("ui_right")
			elif int(action[2]) < 0:
				Input.action_press("ui_left")
			else:
				Input.action_release("ui_right")
				Input.action_release("ui_left")
				
		if action[1] == 'Y':
			if int(action[2]) > 0:
				Input.action_press("ui_down")
			elif int(action[2]) < 0:
				Input.action_press("ui_up")
			else:
				Input.action_release("ui_up")
				Input.action_release("ui_down")
		
	else:
		print('UNKNOW COMMAND')
