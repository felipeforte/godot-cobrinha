extends Node

var serial := SerialPort.new()

var joystick_connected = false

var serialCommand = ''
var defaultPort = "COM1"

@onready var fileAccess: = FileAccess

func _enter_tree():	
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	set_process_priority(-1)

func _ready():
	if not is_multiplayer_authority(): return
	
	serial.got_error.connect(_on_error)
	serial.baudrate = 115200
	#serial.data_received.connect(_on_data_received)
	serial.start_monitoring(serial.baudrate)
	loadFileConfig()
	serial.open(defaultPort)
	
	joystick_connected = serial.is_open()
	
	print('Joystick:connected -> ', joystick_connected)

func loadFileConfig():
	var file_path = "res://joyport_config.txt"
	
	if not FileAccess.file_exists(file_path):
		serial.port = defaultPort
	else:
		var file = FileAccess.open(file_path, FileAccess.READ)
		var file_contents = file.get_as_text().trim_prefix("").trim_suffix("")
		var num = file_contents.to_int()
		defaultPort = "COM%d" % num
		serial.port = defaultPort
		print("filePort:", defaultPort)

func _on_error(where, what):
	print_debug("Got error when %s: %s" % [where, what])

func _exit_tree():
	serial.stop_monitoring()

func _process(delta):
	if not is_multiplayer_authority():	return
	
	if joystick_connected and serial.available() > 0:
		var rec := serial.read_raw(serial.available())
		_on_data_received(rec)
	pass

func _on_data_received(data: PackedByteArray):	
	if data.is_empty(): return
	
	var message = data.get_string_from_utf8()
	
	message = message.split("\n")
	
	if message.is_empty(): return
	
	for item in message:
		if item == "": continue
		_command_interpreter(item)

func send_command(command):
	if joystick_connected:
		print("Joystick:send_command -> ", command)
#		serial_port.write_text(command + '\n')

func _command_interpreter(command: String):
	if not is_multiplayer_authority(): return
	
	var action = command.split(':')
	
	if action.size() < 3: return
	
	if action[0] != "BTN" and action[0] != "AXIS": return
	
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
