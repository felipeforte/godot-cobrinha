extends Node

@onready var number1_label=$number1_label
@onready var number2_label= $number2_label
@onready var symbol_label= $symbol_label
@onready var result_label= $result_label

var numero1
var numero2
var simbolo
var resultado

var buttons: Array = []
var btnCorrect

func _ready():
	number1_label.text = str(numero1)
	number2_label.text = str(numero2)
	symbol_label.text = simbolo
	result_label.text = str(resultado)
	buttons.append($Buttons/ButtonRed)
	buttons.append($Buttons/ButtonGreen)
	buttons.append($Buttons/ButtonBlue)
	buttons.append($Buttons/ButtonYellow)
	set_process_input(true)

func pick_random_symbol() -> String:
	var symbols = ["+", "-", "×", "÷"]
	return symbols[randi() % symbols.size()]

func _input(event):
	if Input.is_action_pressed("vermelho"):
		if btnCorrect == 0:
			print("correto!")
		else:
			print("errado!")
	if Input.is_action_pressed("verde"):
		if btnCorrect == 1:
			print("correto!")
		else:
			print("errado!")
	if Input.is_action_pressed("azul"):
		if btnCorrect == 2:
			print("correto!")
		else:
			print("errado!")
	if Input.is_action_pressed("amarelo"):
		if btnCorrect == 3:
			print("correto!")
		else:
			print("errado!")
