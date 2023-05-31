extends Node

@onready var number1_label=$number1_label
@onready var number2_label= $number2_label
@onready var symbol_label= $symbol_label
@onready var result_label= $result_label

var numero1
var numero2
var simbolo
var resultado

func _ready():
	number1_label.text = str(numero1)
	number2_label.text = str(numero2)
	symbol_label.text = simbolo
	result_label.text = str(resultado)

func pick_random_symbol() -> String:
	var symbols = ["+", "-", "*", "/"]
	return symbols[randi() % symbols.size()]
	
func gera_numeros():
	number1_label = $number1_label
	number2_label = $number2_label
	symbol_label = $symbol_label
	result_label = $result_label
	
	var number1 = randi() % 26  # Gera um número inteiro aleatório entre 0 e 99
	var number2 = randi() % 26  # Gera um número inteiro aleatório entre 0 e 99
	
	var symbol = pick_random_symbol()  # Escolhe um símbolo de operação aleatório
	var result = 0
	
	number1_label.text = str(number1)
	number2_label.text = str(number2)
	symbol_label.text = symbol
	
	
	print("Número 1:", number1)
	print("Número 2:", number2)
	print("Símbolo da operação:", symbol)
	print("Resultado:", result)
	
	
	match symbol:
		"+":
			result = number1 + number2
			print("Resultado:", result)
		"-":
			result = number1 - number2
			print("Resultado:", result)
		"*":
			result = number1 * number2
			print("Resultado:", result)
		"/":
			result = number1 / number2
			print("Resultado:", result)
	result_label.text = str(result)
