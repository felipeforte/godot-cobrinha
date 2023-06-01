extends Node


func is_valid_ip(ip: String) -> bool:
	
	if ip == 'localhost':
		return true
	
	var ip_parts := ip.split(".")
	
	if ip_parts.size() != 4:
		return false
	
	for part in ip_parts:
		var numeric_part := part.to_int()
		
		if numeric_part == null or numeric_part < 0 or numeric_part > 255:
			return false
	
	return true

func generate_random_string(length: int) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var randomString = ""
	
	for i in range(length):
		var randomIndex = randi_range(0, chars.length() - 1)
		randomString += chars.substr(randomIndex, 1)
	
	return randomString
	
func generate_random_number(min,max):
	return randi_range(min,max)

func generate_calc():
	
	
	var symbols = ["+", "-", "×", "÷"]
	var symbol = symbols[randi() % symbols.size()] # Escolhe um símbolo de operação aleatório
	var number1
	var number2
	if symbol == "×":
		number1 = randi_range(2,12)
		number2 = randi_range(2,12)
	elif symbol == "÷":
		var divisores = [2,3,5]
		number2 = divisores[randi_range(0,2)]
		number1 = randi_range(1,12)*number2
	else:
		number1 = randi_range(1,25)
		number2 = randi_range(1,25)
	var result

	
	match symbol:
		"+":
			result = number1 + number2
#			print("Resultado:", result)
		"-":
			result = number1 - number2
#			print("Resultado:", result)
		"×":
			result = number1 * number2
#			print("Resultado:", result)
		"÷":
			#do:
			#	number2 = randi() % 26
			#while (number2 % 2 != 0)
			
			result = number1 / number2
#			print("Resultado:", result)
	
	return [number1, number2, symbol, result]
