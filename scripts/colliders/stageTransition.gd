extends Area2D

# func _ready():
	# Certifique-se de que o Area2D está conectado ao sinal
	# $Area2D.connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	# Verifica se o corpo que entrou é o player
	if body.name == "coelho1" or body.is_in_group("player"):
		print("Player colidiu com o StaticBody2D")
		# Faça algo quando a colisão ocorrer


func _on_body_entered(body: Node2D) -> void:
	# Verifica se o corpo que entrou é o player
	print("Collidiu")
	
	if body.name == "coelho1" or body.is_in_group("coelho1"):
		print("Player colidiu com o StaticBody2D")
		# Faça algo quando a colisão ocorrer
