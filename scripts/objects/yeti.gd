extends Character

@onready var player_detector: Area2D = $DamageReceiver
var player: Node2D
var can_follow_player = true
@onready var damage_spot: Area2D = $DamageSpot

func _process(delta: float) -> void:
	handle_movement()
	handle_animations()
	die()
	follow_player()
	flip_sprites()
	move_and_slide()
	
func _ready() -> void:
	super._ready()
	call_deferred("_find_player")
	player_detector.body_entered.connect(_on_player_detected)

func _find_player():
	var path = "../coelho1"
	if has_node(path):
		player = get_node(path)
		print("✅ Player found:", player)
	else:
		print("❌ Player not found at path:", path)

func _on_player_detected(body):
	if body.name == "coelho1":
		body.health -= meele_damage

func follow_player():
	if player and can_follow_player:
		var direction = (player.global_position - damage_spot.global_position)
		velocity = direction.normalized() *speed
	else:
		velocity = Vector2.ZERO

func handle_movement() -> void:
	if can_move():
		state = State.WALK

func flip_sprites() -> void:
	if velocity.x > 0:
		sprite_position.scale.x = 1
		damage_emitter.scale.x = 1
		damage_spot.scale.x = 1
	elif velocity.x < 0:
		sprite_position.scale.x = -1
		damage_emitter.scale.x = -1
		damage_spot.scale.x = -1

func die():
	if health <= 0:
		speed = 0
		queue_free()

func pop_out():
	queue_free()
