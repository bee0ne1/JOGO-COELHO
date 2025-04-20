extends Area2D

var entered = false

func _ready():
	connect("body_entered",Callable(self,"_on_area2d_body_entered"))
	connect("body_exited",Callable(self,"_on_area2d_body_exited"))


func _on_area2d_body_entered(body):
	entered = true
	#if body.name == "coelho1":
	print("jogador chegou no fim da fase")
	

func _on_area2d_body_exited(body):
	entered = false

func _process(delta):
	if entered == true:
		get_tree().change_scene_to_file("res://scenes/stage2.tscn")



		
