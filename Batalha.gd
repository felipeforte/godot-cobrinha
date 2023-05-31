extends Node

var number1_label: Label
var number2_label: Label
var symbol_label: Label
var result_label: Label

func _ready():
	randomize()
	
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
	result_label.text = str(result)
	
	print("Número 1:", number1)
	print("Número 2:", number2)
	print("Símbolo da operação:", symbol)
	print("Resultado:", result)
	
	
	match symbol:
		"+":
			result = number1 + number2
		"-":
			result = number1 - number2
		"*":
			result = number1 * number2
		"/":
			result = number1 / number2
	

func pick_random_symbol() -> String:
	var symbols = ["+", "-", "*", "/"]
	return symbols[randi() % symbols.size()]
