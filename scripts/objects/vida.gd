extends Sprite2D

@export var full: Texture2D
@export var good: Texture2D
@export var half: Texture2D
@export var bad: Texture2D

@export var max_health: int = 100
var current_health: int = 4
var player

func _ready():
	print("Start vida script")
	current_health = max_health
	texture = full
	_find_player()
	
func _find_player():
	var path = "/root/game/stages/stage1/coelho1"
	if has_node(path):
		player = get_node(path)
		print("Jogador encontrado")
	else:
		print("Jogador não encontrado")

	max_health = player.health
	take_damage()

func _process(_delta: float) -> void:
	
	if(player.health != current_health):
		current_health = player.health
		take_damage()
	
func take_damage():

	# if

	update_texture()

func update_texture():
	   
	# Calcula a porcentagem de vida restante
	var health_percent = float(current_health) / float(max_health)
	
	print("Atualizando UI current ", current_health," max " ,max_health ," percent ", health_percent)
	
	# Atualiza a textura com base na porcentagem
	if health_percent > 0.75:  # Mais de 75% da vida
		texture = full
	elif health_percent > 0.50:  # Entre 50% e 75% da vida
		texture = good
	elif health_percent > 0.25:  # Entre 0% e 25% da vida
		texture = half
	else:  # 0% da vida
		texture = bad
