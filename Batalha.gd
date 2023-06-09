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

signal correto
signal errado

func _ready():
	number1_label.text = str(numero1)
	number2_label.text = str(numero2)
	symbol_label.text = str(simbolo)
	result_label.text = str(resultado)
	buttons.append($Buttons/ButtonRed)
	buttons.append($Buttons/ButtonGreen)
	buttons.append($Buttons/ButtonBlue)
	buttons.append($Buttons/ButtonYellow)
	set_process_input(true)

func pick_random_symbol() -> String:
	var symbols = ["+", "-", "×", "÷"]
	return symbols[randi() % symbols.size()]

func _physics_process(delta):
	_checkBtn()

func _input(event):
	#_checkBtn()
	pass

func _checkBtn():
	var array = ["vermelho","verde","azul","amarelo"]
	for i in 4:
		if Input.is_action_just_pressed(array[i]): 
			if btnCorrect == i:
				print("correto")
			else:
				print("errado")
