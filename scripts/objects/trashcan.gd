extends DestructibleObject

var item_dropped = preload ("res://scenes/objects/carrot.tscn")

func _ready() -> void:
	damage_receiver = get_node("DamageReceiver")
	damage_receiver.damage_received.connect(on_receive_damage.bind())
	object_sprite = get_node("SpritePosition/AnimatedSprite2D/AnimationPlayer")
	sprite_position = get_node("SpritePosition")
	
	
func on_receive_damage(damage: int,direction: Vector2) -> void:
	health -= damage
	print(health)
	print(direction.x)
	if health <= 0:
		object_sprite.play("destroyed") 
		spawn_item()
	else:
		if direction.x == 1:
			sprite_position.scale.x = 1
			object_sprite.play("destructing")
		elif direction.x == -1:
			sprite_position.scale.x = -1
			object_sprite.play("destructing")


func spawn_item():
	if item_dropped:
		var item = item_dropped.instantiate()
		item.position = global_position
		get_parent().add_child(item)
	
func pop_out() -> void:
	queue_free()

func reset_animation() -> void:
	object_sprite.play("idle")
