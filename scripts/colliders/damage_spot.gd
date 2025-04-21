extends Area2D

var enemy
var attacking = false
var player_inside = true
var attack_rate: float = 1

func _ready():
	connect("body_entered",Callable(self,"_on_area2d_body_entered"))
	connect("body_exited",Callable(self,"_on_area2d_body_exited"))
	enemy = get_parent()


func _on_area2d_body_entered(body):
	if body.name == "coelho1":
		enemy.can_follow_player = false
		player_inside = true
		start_attacking()

func _on_area2d_body_exited(body):
	if body.name == "coelho1":
		enemy.can_follow_player = true
		player_inside = false
	
func start_attacking():
	if attacking:
		return 
	attacking = true
	attack_loop()

func attack_loop():
	if not player_inside:
		attacking = false
		return
		
	enemy.state = enemy.State.ATTACK
	await get_tree().create_timer(attack_rate).timeout
	attack_loop()
	
